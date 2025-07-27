package com.muhend.backend.service.ai;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class OpenAiServiceOllama {

    // URL de base pour l'API Ollama
    // Avec : Claude 3.5 Sonnet
    private static final String OLLAMA_API_URL = "http://localhost:11434/api/generate";
    private static final String LLAMA_MODEL = "llama3";
    private final float TEMPERATURE = 0.4F;

    private static final String BASE_SYSTEM_PROMPT = """
                 Vous êtes un assistant spécialisé dans le domaine de la recherche des codes douaniers du commerce international.
                 Votre tâche est d'extraire à partir de la liste générale des codes, tous les codes et leurs descriptions susceptibles de décrire un produit donné.
                 Veuillez répondre uniquement au format JSON avec les clés `code` et `description`. Voir exemples ci-dessous :
                 Exemple 1 :
                    termeRecherche= "bananes"
                    Assistant=
                         {
                           "code": "08",
                           "description": "FRUITS COMESTIBLES; ÉCORCES D'AGRUMES OU DE MELONS"
                         }
                Exemple 2 :
                    termeRecherche= "navigation"
                    Assistant=
                        [
                              {
                                  "code": "88",
                                  "description": "NAVIGATION AÉRIENNE OU SPATIALE"
                              },
                              {
                                  "code": "89",
                                  "description": "NAVIGATION MARITIME OU FLUVIALE"
                              }
                         ]
                """;

    public String demanderAiAide(String question) {
        System.out.println("Méthode demanderAiAide appelée avec la question : " + question);

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Type", "application/json");

        // Préparation des données pour le JSON
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("model", LLAMA_MODEL);
        requestMap.put("prompt", question.replace("\"", "\\\""));
        requestMap.put("temperature", TEMPERATURE);
        requestMap.put("system", BASE_SYSTEM_PROMPT);
        requestMap.put("stream", false);

        String requestBody;
        try {
            requestBody = objectMapper.writeValueAsString(requestMap);
        } catch (JsonProcessingException e) {
            System.out.println("Erreur lors de la création du JSON : " + e.getMessage());
            return "Collections.emptyList()";
        }

        HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);

        System.out.println("Avant l'appel à l'API Ollama");

        try {
            ResponseEntity<String> response = restTemplate.exchange(
                    OLLAMA_API_URL,
                    HttpMethod.POST,
                    entity,
                    String.class
            );

            System.out.println("Après l'appel à l'API Ollama");
            System.out.println("Réponse brute de l'API Ollama : " + response.getBody());

            JsonNode jsonNode = objectMapper.readTree(response.getBody());

            if (jsonNode.has("response")) {
                String textResponse = jsonNode.get("response").asText();
                System.out.println("textResponse : " + textResponse);
                try {
                    int startIndex = textResponse.indexOf('[');
                    int endIndex = textResponse.lastIndexOf(']') + 1;

                    if (startIndex >= 0 && endIndex > startIndex) {
                        String jsonArray = textResponse.substring(startIndex, endIndex);
                        System.out.println("jsonArray : " + jsonArray);
                        return "convertListJsonToPositions(jsonArray)";
                    }
                } catch (Exception e) {
                    System.out.println("Erreur lors de l'extraction du JSON de la réponse : " + e.getMessage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Une erreur est survenue lors de l'appel à l'API Ollama : " + e.getMessage());
        }

        return "Collections.emptyList()";
    }


    private String convertListJsonToPositions(String jsonArrayResponse) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            return "objectMapper.readValue(jsonArrayResponse, new TypeReference<List<Position>>() {})";
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Erreur lors de la conversion JSON -> List<Position>. Retour d'une liste vide.");
            return "Collections.emptyList()";
        }
    }
}
