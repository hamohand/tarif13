package com.muhend.backend.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.muhend.backend.model.Chapitre;
import com.muhend.backend.model.Position;
import com.muhend.backend.model.Position4;
import com.muhend.backend.model.Position6Dz;
import com.muhend.backend.service.ChapitreService;
import com.muhend.backend.service.Position4Service;
import com.muhend.backend.service.Position6DzService;
import com.muhend.backend.service.ai.OpenAiService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@RestController
// --- IMPORTANT --- *******************************************************************
// On supprime "/api" du mapping, car Traefik le gère déjà.
// Spring ne verra que le chemin "/recherche".
// Modifier @RequestMapping("/api/recherche")
// ***********************************************************************************
@RequestMapping("/api/recherche")
//@RequestMapping("/recherche")
public class RechercheController {
    private final ChapitreService chapitreService;
    //    private final OpenAiServiceOld openAiServiceOld;
    //   private  final OpenAiService openAiService;
    private final Position4Service position4Service;
    private final Position6DzService position6DzService;
    private final OpenAiService openAiService;
   // private final OpenAiServiceOllama openAiServiceOllama;
    @Autowired
    public RechercheController(ChapitreService chapitreService, Position4Service position4Service, Position6DzService position6DzService, OpenAiService openAiService) {
        this.chapitreService = chapitreService;
        this.position4Service = position4Service;
        this.position6DzService = position6DzService;
        this.openAiService = openAiService;
      //  this.openAiServiceOllama = openAiServiceOllama;
    }
    //Listes des codes trouvés par l'IA // A transformer en variables locales
    List<String> codesChapitres = new java.util.ArrayList<>();
    List<String> codesPosition4 = new java.util.ArrayList<>();
    List<String> codesPosition6 = new java.util.ArrayList<>();

    //-------------------------------------------------------------------------------
    // Outils communs -------------------------------------------------------------------
    //
    public String userMessage(StringBuilder ragString, String termeRecherche){
        return
                "En utilisant la liste suivante : \n" + ragString + "\n" +
                        "Recherchez tous les items qui contiennent la catégorie qui correspond à  : " + "\""+termeRecherche+"\"" + " ." +
                        "L'aspect qui nous intéresse est la valeur du code.";

    }
    //
    public String codesReponseIa(StringBuilder ragString, String termeRecherche) {
        String prompt = userMessage(ragString, termeRecherche);
        System.out.println("Terme recherche --- : " + termeRecherche);
        // La réponse avec l'IA
        try {
            return openAiService.demanderAiAide(prompt); // OPENAI - AI - AI - AI - AI - AI - AI - AI -
            //return openAiServiceOllama.demanderAiAide(prompt); // OLLAMA - AI - AI - AI - AI - AI - AI - AI -
        } catch (Exception e) {
            return null;
        }
    }

    //****************************************************************************************
    // --------------------------------- Accueil ---------------------------------------------
    //*****************************************************************************************

    @GetMapping(value = "", produces = "text/plain")
    @CrossOrigin(
            origins = {"http://localhost:4200", "http://217.65.146.13:4200"},
            methods = {RequestMethod.GET, RequestMethod.POST}
    )
    public String accueil(){
        return "Bienvenue dans l'application universelle du commerce international";
    }

    //****************************************************************************************
    // --------------------------------- CHAPITRES ---------------------------------------------
    //*****************************************************************************************

    @GetMapping(value = "/chapitres", produces = "text/plain")
    @CrossOrigin(
            origins = {"http://localhost:4200", "http://217.65.146.13:4200"},
            methods = {RequestMethod.GET, RequestMethod.POST}
    )
    public String rechercheChapitresAvecAi(@RequestParam String termeRecherche) {
        try {
            //List<String> codesChapitres = new java.util.ArrayList<>(); //.......................
            codesChapitres= null; // réinitialisation
            // Étape 1 : Construire la liste de tous les chapitres à rechercher
            StringBuilder chapitresRag = creationRagChapitre();
            // Étape 2 : Appeler l'IA pour obtenir la réponse brute
            String reponseIaJson = codesReponseIa(chapitresRag, termeRecherche);
            // Nettoyer la réponse brute
            String jsonNettoye = cleanJsonString(reponseIaJson);
            if (!isValidJson(jsonNettoye)) {
                return "Le terme entré est insuffisant, aucune réponse trouvée. Donnez plus de précisions.";
            }
            // Transformer la réponse nettoyée en liste de codes
            codesChapitres = conversionReponseIaToList(jsonNettoye);

            // Étape 3 : Formatage final des chapitres
            StringBuilder resultatChapitres = new StringBuilder("** CHAPITRES **\n\n");
            if (!codesChapitres.isEmpty()) {
                for (String code : codesChapitres) {
                    String description = chapitreService.getChapitreByCode(code.trim()).get().getDescription();
                    resultatChapitres.append("- Code = ").append(code)
                            .append("\n")
                            .append("Description : ").append(description)
                            .append("\n\n")
                            ;
                }
            } else {
                resultatChapitres.append("Terme insuffisant, aucune réponse trouvée. Donnez plus de précisions.");
            }
            return resultatChapitres.toString();
        } catch (Exception e) {
            return "Une erreur est survenue : " + e.getMessage();
        }
    }
    //
    public StringBuilder creationRagChapitre(){
        // liste chapitres
        List<Chapitre> listePositions = chapitreService.getAllChapitres();
        // Etape : RAG
        StringBuilder ragString = new StringBuilder();
        for (Chapitre chapitre : listePositions){
            ragString.append(chapitre.getCode())
                    .append(" - ")
                    .append(chapitre.getDescription())
                    .append("\n")
            ;
        }
        //System.out.println("RAG Liste chapitres : " + ragString + "------------- ");
        return ragString;
    } //



    // *******************************************************************************************
    // --------------------------------- POSITION 4 ---------------------------------------------
    // *******************************************************************************************
    @GetMapping(path = "/positions4", produces = "text/plain")
    @CrossOrigin(
            origins = {"http://localhost:4200", "http://217.65.146.13:4200"},
            methods = {RequestMethod.GET, RequestMethod.POST}
    )
    public String recherchePosition4AvecAi(@RequestParam String termeRecherche) {
        //List<String> codesPosition4 = new java.util.ArrayList<>(); //.......................
        codesPosition4 = null; // Réinitialisation
        try {
            // lancer d'abord 'Chapitres'
            String reponseChapitre = rechercheChapitresAvecAi(termeRecherche);
//            if (codesChapitres == null || codesChapitres.isEmpty()) {
//                return "";
//            }
            //RAG
            StringBuilder ragContent = buildRagForPosition4(codesChapitres);
            if (ragContent == null) {
                return "Terme Position 4 insuffisant, aucune réponse trouvée. Donnez plus de précisions.";
            }
            //IA
            String iaResponse = codesReponseIa(ragContent, termeRecherche);
            String cleanedIaResponse = cleanJsonString(iaResponse);

            if (!isValidJson(cleanedIaResponse)) {
                return "Terme Position 4 insuffisant, aucune réponse trouvée. Donnez plus de précisions.";
            }

            System.out.println("Nettoyage JSON : " + cleanedIaResponse);
            codesPosition4 = conversionReponseIaToList(cleanedIaResponse);
            // construction de la réponse
            StringBuilder formattedResponse = new StringBuilder();
            formattedResponse.append(reponseChapitre).append("\n\n"); // Commencer par mettre le résultat de 'Chapitre'
            if (!codesPosition4.isEmpty()) {
                //Pour afficher les POSITIONS-4 il faut décommenter
                formattedResponse.append("** POSITION(S)-4 **\n\n");
                for (String code : codesPosition4) {
                    String description = position4Service.getPositionByCode(code.trim()).get().getDescription();
                    if (description == null) {
                        description = "vide";
                    }
                    System.out.println(" - Code : " + code.trim());
                    System.out.println("   Description : " + description);
                    formattedResponse
                            .append("- Code = ").append(code)
                            .append("\n")
                            .append("Description : ").append(description)
                            .append("\n\n");
                }
                return formattedResponse.toString();
            } else {
                return formattedResponse.append("Terme insuffisant, aucune réponse trouvée. Donnez plus de précisions.").toString();
            }
        } catch (Exception e) {
            return "Une erreur est survenue : " + e.getMessage();
        }
    }

    //
    public StringBuilder buildRagForPosition4(List<String> codesChapitres) {
        StringBuilder position4Details = new StringBuilder();
        for (String chapterCode : codesChapitres) {
            System.out.println("Code pour position 4 : " + chapterCode + "------------------------------------- ");
            String chapterCodePrefix = chapterCode + "%";
            List<Position4> results = position4Service.getPosition4sByPrefix(chapterCodePrefix);
            for (Position4 position4 : results) {
                position4Details
                        .append(position4.getCode())
                        .append(" : ")
                        .append(position4.getDescription())
                        .append("\n");
            }
        }
        System.out.println("Rag position4 :\n" + position4Details + "------------------------------------- ");
        return position4Details;
    }

    // *******************************************************************************************
    // --------------------------------- POSITION 6 Dz ---------------------------------------------
    // *******************************************************************************************
    @GetMapping(path = "/positions6", produces = "text/plain")
    @CrossOrigin(
            origins = {"http://localhost:4200", "http://217.65.146.13:4200"},
            methods = {RequestMethod.GET, RequestMethod.POST}
    )
    public String recherchePosition6AvecAi(@RequestParam String termeRecherche) {
        // List<String> codesPosition6 = new java.util.ArrayList<>(); //.......................
        codesPosition6 = null; // réinitialisation
        try {
            // lancer d'abord 'Position4'
            String reponsePosition4 = recherchePosition4AvecAi(termeRecherche);//calcule aussi 'codesPosition4'
//            if (codesPosition4 == null || codesPosition4.isEmpty()) {
//                return "";
//            }
            //RAG
            StringBuilder ragContent = buildRagForPosition6(codesPosition4);
            if (ragContent == null || ragContent.isEmpty()) {
                return "Terme Position 6 insuffisant, aucune réponse n'a été trouvée. Donnez plus de précisions.";
            }
            // IA
            String iaRawResponse = codesReponseIa(ragContent, termeRecherche);
            String cleanedIaResponse = cleanJsonString(iaRawResponse);

            if (!isValidJson(cleanedIaResponse)) {
                return "Terme insuffisant, aucune réponse n'a été trouvée. Donnez plus de précisions.";
            }

            System.out.println("cleanedIaResponse : " + cleanedIaResponse);
            codesPosition6 = conversionReponseIaToList(cleanedIaResponse);
            // construction de la réponse
            // StringBuilder formattedResponse = new StringBuilder();
//            formattedResponse.append(reponseChapitre).append("\n\n"); // Commencer par le résultat de 'Chapitre'
//            if (!codesPosition4.isEmpty()) {
//                formattedResponse.append("POSITION(S)-4 :\n\n");
//                for (String code : codesPosition4) {
//                    String description = position4Service.getPosition4ByCode(code.trim()).getDescription();
//                    if (description == null) {}}
            // construction de la réponse
            StringBuilder formattedResponse = new StringBuilder();
            //formattedResponse.append(reponsePosition4).append("\n\n"); // Commencer par le résultat de 'Position4'
            if (!codesPosition6.isEmpty()) {
                //System.out.println("** POSITION(S)-6 **\n\n");
      //          formattedResponse.append(reponsePosition4).append("\n\n"); // Commencer par  le résultat de 'Position4' //..................
      //          formattedResponse.append("** POSITION(S)-6 **\n\n"); // ensuite le résultat de 'Position6' ensuite 'Position4' //..................
                for (String code : codesPosition6) {
                    //System.out.println(" - Code avant appel :" + code);
                    Position6Dz position6 = position6DzService.getPositionByCode(code.trim()).get();
                    String description = position6.getDescription();
                    //System.out.println(" - Code :" + code.trim());
                    formattedResponse
                        .append("- Code = ").append(code)
                        .append("\n")
     //                   .append("Description : ").append(description) //...............
                        .append("\n\n");
                }

                return formattedResponse.toString();
            } else {
                return formattedResponse.append("Terme insuffisant ou inconnu, aucune réponse n'a été trouvée. Donnez plus de précisions..").toString();
            }
        } catch (Exception e) {
            return "Une erreur est survenue : " + e.getMessage();
        }
    }


    public StringBuilder buildRagForPosition6(List<String> codesPosition4) {
        StringBuilder ragBuilder = new StringBuilder();
        for (String code : codesPosition4) {
            System.out.println("Code pour position 6 : " + code + " -------------------------------------");
            String position4Prefix = code + "%";
            List<Position6Dz> positions6 = position6DzService.getPosition6DzsByPrefix(position4Prefix);

            for (Position6Dz position6 : positions6) {
                ragBuilder.append(position6.getCode())
                        .append(" : ")
                        .append(position6.getDescription())
                        .append("\n");
            }
        }
        System.out.println("Rag position 6 : \n" + ragBuilder + "-------------------------------------");
        return ragBuilder;
    }

    // ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    // OUTILS  Réponse IA :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    //Création d'un tableau Java à partir de la réponse de l'IA
    public List<String> conversionReponseIaToList(String cleanedJson){
        List<String> listeCodes = extractCodesFromJson(cleanedJson);
        System.out.println("listeCodes 'conversionReponseIaToList' : "+ listeCodes);
        return listeCodes;
    }
    //
    public List<String> extractCodesFromJson(String jsonInput) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();

            // Tente de parser comme un objet unique
            if (jsonInput.trim().startsWith("{")) {
                Position position = objectMapper.readValue(jsonInput, Position.class);
                return Collections.singletonList(position.getCode());
            }
            // Tente de parser comme un tableau
            else if (jsonInput.trim().startsWith("[")) {
                List<Position> positions = objectMapper.readValue(jsonInput,
                        new TypeReference<List<Position>>() {});
                return positions.stream()
                        .map(Position::getCode)
                        .collect(Collectors.toList());
            }

            return Collections.emptyList();
        } catch (JsonProcessingException e) {
            System.out.println("Erreur de conversion JSON" + e);
            return Collections.emptyList();
        }
    }


    //Nettoyage du Json ----------------------------------------------------------------
    private static final String ERROR_EMPTY_JSON = "Réponse JSON vide ou nulle !";
    private static final String ERROR_INVALID_JSON = "Veuillez donner plus de précisions dans votre question. La réponse n'est pas un JSON valide : ";
    private static final String JSON_PREFIX = "json";
    private static final char BACKTICK = '`';

    private String cleanJsonString(String jsonResponse) {
        if (jsonResponse == null || jsonResponse.isBlank()) {
            throw new RuntimeException(ERROR_EMPTY_JSON);
        }

        String cleanedJson = jsonResponse.trim();
        cleanedJson = removeEnclosingBackticks(cleanedJson);

        if (cleanedJson.startsWith(JSON_PREFIX)) {
            cleanedJson = cleanedJson.substring(JSON_PREFIX.length()).trim();
        }

        if (!isValidJson(cleanedJson)) {
            throw new RuntimeException(ERROR_INVALID_JSON + cleanedJson);
        }

        return cleanedJson;
    }

    private String removeEnclosingBackticks(String json) {
        while (json.startsWith(String.valueOf(BACKTICK)) || json.endsWith(String.valueOf(BACKTICK))) {
            json = json.substring(1, json.length() - 1).trim();
        }
        return json;
    }

    //Vérifie si JSON
    private boolean isValidJson(String json) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.readTree(json); // Si le parsing réussit, c'est un JSON valide
            return true;
        } catch (JsonProcessingException e) {
            return false;
        }
    }

}
