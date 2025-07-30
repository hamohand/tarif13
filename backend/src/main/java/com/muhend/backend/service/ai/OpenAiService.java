package com.muhend.backend.service.ai;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
public class OpenAiService {

    /**
     * Pour utiliser GPT-4o ou toute autre API d'OpenAI, vous devez d'abord intégrer leur SDK ou utiliser un client HTTP pour appeler l'API.
     */
    @Value("${OPENAI_API_KEY}")
    private String openAiKey;

    private final String openaiApiUrl = "https://api.openai.com/v1/chat/completions"; // URL corrigée
    //private static final String OPENAI_API_URL = "http://localhost:11434/completions\n"; // URL

    private final String openaiModel = "gpt-4.1";
    //   private final String OPENAI_MODEL = "llama3";
    private final int maxTokens = 500;
    private final float temperature = 0.1F;

    private final String userMessageSystem = """
             Vous êtes un assistant multilingue, vous êtes spécialisé dans le domaine de la recherche des codes douaniers du commerce international.
             Votre tâche est d'extraire à partir de la liste générale des codes, tous les codes et leurs descriptions susceptibles de décrire un produit donné.
             Veuillez répondre uniquement au format JSON avec la clé `code`. Voir exemples de réponses de l'assistant ci-dessous :
             Exemple 1 :
                Assistant=
                     {
                       "code": "08"
                     }
            Exemple 2 :
                Assistant=
                    [
                          {
                              "code": "88",
                          },
                          {
                              "code": "89",
                          }
                    ]
            """;
    //
//    public List<String> demanderAiAide(String question) {
    public String demanderAiAide(String question) {
        //Préparation du client REST
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add("Authorization", "Bearer " + openAiKey);
        httpHeaders.add("Content-Type", "application/json");

        // Construction robuste du corps JSON
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", openaiModel); // Spécifiez le modèle
        requestBody.put("messages", new Object[]{
                Map.of("role", "system", "content", userMessageSystem),
                Map.of("role", "user", "content", question)
        });
        requestBody.put("max_tokens", maxTokens);  // 150 // Limite du nombre de tokens
        requestBody.put("temperature", temperature); // 0.1 // Ajustement de la créativité

        // Sérialisation en JSON avec ObjectMapper
        ObjectMapper objectMapper = new ObjectMapper();
        String body;
        try {
            body = objectMapper.writeValueAsString(requestBody);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la sérialisation JSON.", e);
        }

        // Envoi de la requête POST
        HttpEntity<String> entity = new HttpEntity<>(body, httpHeaders);
        try {
            ResponseEntity<String> response = restTemplate.exchange(
                    openaiApiUrl,
                    HttpMethod.POST,
                    entity,
                    String.class
            );

            // Lire le contenu JSON
            String responseBody = response.getBody();
            if (responseBody == null) {
                return "Aucune réponse n'a été trouvée.";
            }

            // Extraire le champ `choices[0].message.content` de la réponse de l'API
            JsonNode rootNode = objectMapper.readTree(responseBody); //transforme en JSON
            String assistantMessage = rootNode
                    .path("choices")
                    .get(0)
                    .path("message")
                    .path("content")
                    .asText();

            System.out.println("AI : Réponse STRING assistantMessage ---- : " + assistantMessage);


            //return listeCodes;
            return assistantMessage;

        } catch (Exception e) {
            // Logs pour un meilleur diagnostic
            System.err.println("Erreur lors de la requête à l'API OpenAI : " + e.getMessage());
            return "L'appel à l'API OpenAI a échoué.";
        }

    }
}

