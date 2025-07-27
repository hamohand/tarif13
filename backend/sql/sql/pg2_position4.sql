DROP TABLE IF EXISTS position4;

CREATE TABLE position4 (
                           id BIGSERIAL PRIMARY KEY,
                           description VARCHAR(1024) NOT NULL,
                           code VARCHAR(255) NOT NULL,
                           section VARCHAR(255),
                           CONSTRAINT uk_position4_code UNIQUE (code)
);

-- Nettoyer les données existantes pour supprimer tous les espaces inutiles (préventif pour "données sales")
UPDATE position4 SET code = TRIM(code);

-- Création de la fonction pour nettoyer les champs avant insertion ou mise à jour (trigger)
CREATE OR REPLACE FUNCTION clean_code_function()
    RETURNS TRIGGER AS $$
BEGIN
    -- Nettoyer automatiquement la valeur de "code" en supprimant espaces au début/fin
    NEW.code = TRIM(NEW.code);
    RETURN NEW; -- Retourner la ligne nettoyée
END;
$$ LANGUAGE plpgsql;

-- Création du trigger lié à la fonction pour gérer les insertions/mises à jour
CREATE TRIGGER clean_code_trigger
    BEFORE INSERT OR UPDATE ON position4
    FOR EACH ROW
EXECUTE FUNCTION clean_code_function();

-- Ajout d'une contrainte pour s'assurer que 'code' ne contient jamais de valeurs incorrectes
ALTER TABLE position4 ADD CONSTRAINT chk_code_no_spaces CHECK (code = TRIM(code));

-- Création d'un index sur la colonne 'code' pour accélérer les recherches par cette colonne
CREATE INDEX idx_code_position4 ON position4 (code);

INSERT INTO position4 (description, code) VALUES
                                                ('Chevaux, ânes, mulets et bardots, vivants.', '0101'),
                                                  ('Animaux vivants de l''espèce bovine:', '0102'),

                                                  ('Animaux vivants de l''espèce porcine:', '0103'),

                                                  ('Animaux vivants des espèces ovine ou caprine:', '0104'),

                                                  ('Coqs, poules, canards, oies, dindons, dindes et pintades, vivants, des espèces domestiques:', '0105'),

                                                  ('Autres animaux vivants:', '0106'),

                                                  ('Viandes des animaux de l''espèce bovine, fraîches ou réfrigérées:', '0201'),

                                                  ('Viandes des animaux de l''espèce bovine, congelées:', '0202'),

                                                  ('Viandes des animaux de l''espèce porcine, fraîches, réfrigérées ou congelées:', '0203'),

                                                  ('Viandes des animaux des espèces ovine ou caprine, fraîches, réfrigérées ou congelées:', '0204'),

                                                  ('Viandes des animaux des espèces chevaline, asine ou mulassière, fraîches, réfrigérées ou congelées:', '0205'),

                                                  ('Abats comestibles des animaux des espèces bovine, porcine, ovine, caprine, chevaline, asine ou mulassière, frais, réfrigérés ou congelés:', '0206'),

                                                  ('Viandes et abats comestibles, frais, réfrigérés ou congelés, des volailles du no 0105 :', '0207'),

                                                  ('Autres viandes et abats comestibles, frais, réfrigérés ou congelés:', '0208'),

                                                  ('Lard sans parties maigres, graisse de porc et graisse de volailles non fondues ni autrement extraites, frais, réfrigérés, congelés, salés ou en saumure, séchés ou fumés:', '0209'),

                                                  ('Viandes et abats comestibles, salés ou en saumure, séchés ou fumés; farines et poudres, comestibles, de viandes ou d''abats:', '0210'),

                                                  ('Poissons vivants:', '0301'),

                                                  ('Poissons frais ou réfrigérés, à l''exception des filets de poissons et autre chair de poissons du no 0304 :', '0302'),

                                                  ('Poissons congelés, à l''exception des filets de poissons et autre chair de poissons du no 0304 :', '0303'),

                                                  ('Filets de poissons et autre chair de poissons (même hachée), frais, réfrigérés ou congelés:', '0304'),

                                                  ('Poissons séchés, salés ou en saumure; poissons fumés, même cuits avant ou pendant le fumage:', '0305'),

                                                  ('Crustacés, même décortiqués, vivants, frais, réfrigérés, congelés, séchés, salés ou en saumure; crustacés, même décortiqués, fumés, même cuits avant ou pendant le fumage; crustacés non décortiqués, cuits à l’eau ou à la vapeur, même réfrigérés, congelés, séchés, salés ou en saumure:', '0306'),

                                                  ('Mollusques, même séparés de leur coquille, vivants, frais, réfrigérés, congelés, séchés, salés ou en saumure; mollusques, même décortiqués, fumés, même cuits avant ou pendant le fumage:', '0307'),

                                                  ('Invertébrés aquatiques autres que les crustacés et mollusques, vivants, frais, réfrigérés, congelés, séchés, salés ou en saumure; invertébrés aquatiques autres que les crustacés et mollusques, fumés, même cuits avant ou pendant le fumage:', '0308'),

                                                  ('Farines, poudres et agglomérés sous forme de pellets de poissons, crustacés, mollusques et autres invertébrés aquatiques, propres à l’alimentation humaine:', '0309'),

                                                  ('Lait et crème de lait, non concentrés ni additionnés de sucre ou d''autres édulcorants:', '0401'),

                                                  ('Lait et crème de lait, concentrés ou additionnés de sucre ou d''autres édulcorants:', '0402'),

                                                  ('Yoghourt; babeurre, lait et crème caillés, képhir et autres laits et crèmes fermentés ou acidifiés, même concentrés ou additionnés de sucre ou d''autres édulcorants ou aromatisés ou additionnés de fruits ou de cacao:', '0403'),

                                                  ('Lactosérum, même concentré ou additionné de sucre ou d''autres édulcorants; produits consistant en composants naturels du lait, même additionnés de sucre ou d''autres édulcorants, non dénommés ni compris ailleurs:', '0404'),

                                                  ('Beurre et autres matières grasses provenant du lait; pâtes à tartiner laitières:', '0405'),

                                                  ('Fromages et caillebotte:', '0406'),

                                                  ('Œufs d''oiseaux, en coquilles, frais, conservés ou cuits:', '0407'),

                                                  ('Œufs d''oiseaux, dépourvus de leurs coquilles, et jaunes d''œufs, frais, séchés, cuits à l''eau ou à la vapeur, moulés, congelés ou autrement conservés, même additionnés de sucre ou d''autres édulcorants:', '0408'),

                                                  ('Miel naturel', '0409'),

                                                  ('Insectes et autres produits comestibles d’origine animale, non dénommés ni compris ailleurs:', '0410'),

                                                  ('Cheveux bruts, même lavés ou dégraissés; déchets de cheveux', '0501'),

                                                  ('Soies de porc ou de sanglier; poils de blaireau et autres poils pour la brosserie; déchets de ces soies ou poils:', '0502'),

                                                  ('Boyaux, vessies et estomacs d''animaux, entiers ou en morceaux, autres que ceux de poissons, à l''état frais, réfrigéré, congelé, salé ou en saumure, séché ou fumé', '0504'),

                                                  ('Peaux et autres parties d''oiseaux revêtues de leurs plumes ou de leur duvet, plumes et parties de plumes (même rognées), duvet, bruts ou simplement nettoyés, désinfectés ou traités en vue de leur conservation; poudres et déchets de plumes ou de parties de plumes:', '0505'),

                                                  ('Os et cornillons, bruts, dégraissés, simplement préparés (mais non découpés en forme), acidulés ou dégélatinés; poudres et déchets de ces matières:', '0506'),

                                                  ('Ivoire, écaille de tortue, fanons (y compris les barbes) de baleine ou d''autres mammifères marins, cornes, bois, sabots, ongles, griffes et becs, bruts ou simplement préparés mais non découpés en forme; poudres et déchets de ces matières:', '0507'),

                                                  ('Corail et matières similaires, bruts ou simplement préparés, mais non autrement travaillés; coquilles et carapaces de mollusques, de crustacés ou d''échinodermes et os de seiches, bruts ou simplement préparés, mais non découpés en forme, leurs poudres et leurs déchets:', '0508'),

                                                  ('Ambre gris, castoréum, civette et musc; cantharides; bile, même séchée; glandes et autres substances d''origine animale utilisées pour la préparation de produits pharmaceutiques, fraîches, réfrigérées, congelées ou autrement conservées de façon provisoire', '0510'),

                                                  ('Produits d''origine animale, non dénommés ni compris ailleurs; animaux morts des chapitres 1 ou 3, impropres à l''alimentation humaine:', '0511'),

                                                  ('Bulbes, oignons, tubercules, racines tubéreuses, griffes et rhizomes, en repos végétatif, en végétation ou en fleur; plants, plantes et racines de chicorée autres que les racines du no 1212 :', '0601'),

                                                  ('Autres plantes vivantes (y compris leurs racines), boutures et greffons; blanc de champignons:', '0602'),

                                                  ('Fleurs et boutons de fleurs, coupés, pour bouquets ou pour ornements, frais, séchés, blanchis, teints, imprégnés ou autrement préparés:', '0603'),

                                                  ('Feuillages, feuilles, rameaux et autres parties de plantes, sans fleurs ni boutons de fleurs, et herbes, mousses et lichens, pour bouquets ou pour ornements, frais, séchés, blanchis, teints, imprégnés ou autrement préparés:', '0604'),

                                                  ('Pommes de terre, à l''état frais ou réfrigéré:', '0701'),

                                                  ('Tomates, à l''état frais ou réfrigéré', '0702'),

                                                  ('Oignons, échalotes, aulx, poireaux et autres légumes alliacés, à l''état frais ou réfrigéré:', '0703'),

                                                  ('Choux, choux-fleurs, choux frisés, choux-raves et produits comestibles similaires du genre Brassica, à l''état frais ou réfrigéré:', '0704'),

                                                  ('Laitues (Lactuca sativa) et chicorées (Cichorium spp.), à l''état frais ou réfrigéré:', '0705'),

                                                  ('Carottes, navets, betteraves à salade, salsifis, céleris-raves, radis et racines comestibles similaires, à l''état frais ou réfrigéré:', '0706'),

                                                  ('Concombres et cornichons, à l''état frais ou réfrigéré:', '0707'),

                                                  ('Légumes à cosse, écossés ou non, à l''état frais ou réfrigéré:', '0708'),

                                                  ('Autres légumes, à l''état frais ou réfrigéré:', '0709'),

                                                  ('Légumes, non cuits ou cuits à l''eau ou à la vapeur, congelés:', '0710'),

                                                  ('Légumes conservés provisoirement, mais impropres, en l’état, à l’alimentation:', '0711'),

                                                  ('Légumes secs, même coupés en morceaux ou en tranches ou bien broyés ou pulvérisés, mais non autrement préparés:', '0712'),

                                                  ('Légumes à cosse secs, écossés, même décortiqués ou cassés:', '0713'),

                                                  ('Racines de manioc, d''arrow-root ou de salep, topinambours, patates douces et racines et tubercules similaires à haute teneur en fécule ou en inuline, frais, réfrigérés, congelés ou séchés, même débités en morceaux ou agglomérés sous forme de pellets; moelle de sagoutier:', '0714'),

                                                  ('Noix de coco, noix du Brésil et noix de cajou, fraîches ou sèches, même sans leurs coques ou décortiquées:', '0801'),

                                                  ('Autres fruits à coques, frais ou secs, même sans leurs coques ou décortiqués:', '0802'),

                                                  ('Bananes, y compris les plantains, fraîches ou sèches:', '0803'),

                                                  ('Dattes, figues, ananas, avocats, goyaves, mangues et mangoustans, frais ou secs:', '0804'),

                                                  ('Agrumes, frais ou secs:', '0805'),

                                                  ('Raisins, frais ou secs:', '0806'),

                                                  ('Melons (y compris les pastèques) et papayes, frais:', '0807'),

                                                  ('Pommes, poires et coings, frais:', '0808'),

                                                  ('Abricots, cerises, pêches (y compris les brugnons et nectarines), prunes et prunelles, frais:', '0809'),

                                                  ('Autres fruits frais:', '0810'),

                                                  ('Fruits, non cuits ou cuits à l''eau ou à la vapeur, congelés, même additionnés de sucre ou d''autres édulcorants:', '0811'),

                                                  ('Fruits conservés provisoirement, mais impropres, en l’état, à l’alimentation:', '0812'),

                                                  ('Fruits séchés autres que ceux des nos 0801  à 0806  inclus; mélanges de fruits séchés ou de fruits à coques du présent chapitre:', '0813'),

                                                  ('Écorces d''agrumes ou de melons (y compris de pastèques), fraîches, congelées, présentées dans l''eau salée, soufrée ou additionnée d''autres substances servant à assurer provisoirement leur conservation ou bien séchées', '0814'),

                                                  ('Café, même torréfié ou décaféiné; coques et pellicules de café; succédanés du café contenant du café, quelles que soient les proportions du mélange:', '0901'),

                                                  ('Thé, même aromatisé:', '0902'),

                                                  ('Maté', '0903'),

                                                  ('Poivre du genre Piper; piments du genre Capsicum ou du genre Pimenta, séchés ou broyés ou pulvérisés:', '0904'),

                                                  ('Vanille:', '0905'),

                                                  ('Cannelle et fleurs de cannelier:', '0906'),

                                                  ('Girofles (antofles, clous et griffes):', '0907'),

                                                  ('Noix muscades, macis, amomes et cardamomes:', '0908'),

                                                  ('Graines d''anis, de badiane, de fenouil, de coriandre, de cumin, de carvi; baies de genièvre:', '0909'),

                                                  ('Gingembre, safran, curcuma, thym, feuilles de laurier, curry et autres épices:', '0910'),

                                                  ('Froment (blé) et méteil:', '1001'),

                                                  ('Seigle:', '1002'),

                                                  ('Orge:', '1003'),

                                                  ('Avoine:', '1004'),

                                                  ('Maïs:', '1005'),

                                                  ('Riz:', '1006'),

                                                  ('Sorgho à grains:', '1007'),

                                                  ('Sarrasin, millet et alpiste; autres céréales:', '1008'),

                                                  ('Farines de froment (blé) ou de méteil:', '1101'),

                                                  ('Farines de céréales autres que de froment (blé) ou de méteil:', '1102'),

                                                  ('Gruaux, semoules et agglomérés sous forme de pellets, de céréales:', '1103'),

                                                  ('Grains de céréales autrement travaillés (mondés, aplatis, en flocons, perlés, tranchés ou concassés, par exemple), à l''exception du riz du no 1006 ; germes de céréales, entiers, aplatis, en flocons ou moulus:', '1104'),

                                                  ('Farine, semoule, poudre, flocons, granulés et agglomérés sous forme de pellets, de pommes de terre:', '1105'),

                                                  ('Farines, semoules et poudres de légumes à cosse secs du no 0713 , de sagou ou des racines ou tubercules du no 0714  et des produits du chapitre 8:', '1106'),

                                                  ('Malt, même torréfié:', '1107'),

                                                  ('Amidons et fécules; inuline:', '1108'),

                                                  ('Gluten de froment (blé), même à l''état sec', '1109'),

                                                  ('Fèves de soja, même concassées:', '1201'),

                                                  ('Arachides non grillées ni autrement cuites, même décortiquées ou concassées:', '1202'),

                                                  ('Coprah', '1203'),

                                                  ('Graines de lin, même concassées:', '1204'),

                                                  ('Graines de navette ou de colza, même concassées:', '1205'),

                                                  ('Graines de tournesol, même concassées:', '1206'),

                                                  ('Autres graines et fruits oléagineux, même concassés:', '1207'),

                                                  ('Farines de graines ou de fruits oléagineux, autres que la farine de moutarde:', '1208'),

                                                  ('Graines, fruits et spores à ensemencer:', '1209'),

                                                  ('Cônes de houblon frais ou secs, même broyés, moulus ou sous forme de pellets; lupuline:', '1210'),

                                                  ('Plantes, parties de plantes, graines et fruits des espèces utilisées principalement en parfumerie, en médecine ou à usages insecticides, parasiticides ou similaires, frais, réfrigérés, congelés ou séchés, même coupés, concassés ou pulvérisés:', '1211'),

                                                  ('Caroubes, algues, betteraves à sucre et cannes à sucre, fraîches, réfrigérées, congelées ou séchées, même pulvérisées; noyaux et amandes de fruits et autres produits végétaux (y compris les racines de chicorée non torréfiées de la variété Cichorium intybus sativum), servant principalement à l''alimentation humaine, non dénommés ni compris ailleurs:', '1212'),

                                                  ('Pailles et balles de céréales brutes, même hachées, moulues, pressées ou agglomérées sous forme de pellets', '1213'),

                                                  ('Rutabagas, betteraves fourragères, racines fourragères, foin, luzerne, trèfle, sainfoin, choux fourragers, lupin, vesces et produits fourragers similaires, même agglomérés sous forme de pellets:', '1214'),

                                                  ('Gomme laque; gommes, résines, gommes-résines et oléorésines (baumes, par exemple), naturelles:', '1301'),

                                                  ('Sucs et extraits végétaux; matières pectiques, pectinates et pectates; agar-agar et autres mucilages et épaississants dérivés des végétaux, même modifiés:', '1302'),

                                                  ('Matières végétales des espèces principalement utilisées en vannerie ou en sparterie (bambous, rotins, roseaux, joncs, osiers, raphia, pailles de céréales nettoyées, blanchies ou teintes, écorces de tilleul, par exemple):', '1401'),

                                                  ('Produits végétaux non dénommés ni compris ailleurs:', '1404'),

                                                  ('Graisses de porc (y compris le saindoux) et graisses de volailles, autres que celles du no 0209  ou du no 1503 :', '1501'),

                                                  ('Graisses des animaux des espèces bovine, ovine ou caprine, autres que celles du no 1503 :', '1502'),

                                                  ('Stéarine solaire, huile de saindoux, oléostéarine, oléomargarine et huile de suif, non émulsionnées, ni mélangées ni autrement préparées:', '1503'),

                                                  ('Graisses et huiles et leurs fractions, de poissons ou de mammifères marins, même raffinées, mais non chimiquement modifiées:', '1504'),

                                                  ('Graisse de suint et substances grasses dérivées, y compris la lanoline:', '1505'),

                                                  ('Autres graisses et huiles animales et leurs fractions, même raffinées, mais non chimiquement modifiées', '1506'),

                                                  ('Huile de soja et ses fractions, même raffinées, mais non chimiquement modifiées:', '1507'),

                                                  ('Huile d''arachide et ses fractions, même raffinées, mais non chimiquement modifiées:', '1508'),

                                                  ('Huile d''olive et ses fractions, même raffinées, mais non chimiquement modifiées:', '1509'),

                                                  ('Autres huiles et leurs fractions, obtenues exclusivement à partir d''olives, même raffinées, mais non chimiquement modifiées et mélanges de ces huiles ou fractions avec des huiles ou fractions du no 1509 :', '1510'),

                                                  ('Huile de palme et ses fractions, même raffinées, mais non chimiquement modifiées:', '1511'),

                                                  ('Huiles de tournesol, de carthame ou de coton et leurs fractions, même raffinées, mais non chimiquement modifiées:', '1512'),

                                                  ('Huiles de coco (huile de coprah), de palmiste ou de babassu et leurs fractions, même raffinées, mais non chimiquement modifiées:', '1513'),

                                                  ('Huiles de navette, de colza ou de moutarde et leurs fractions, même raffinées, mais non chimiquement modifiées:', '1514'),

                                                  ('Autres graisses et huiles végétales ou d’origine microbienne (y compris l''huile de jojoba) et leurs fractions, fixes, même raffinées, mais non chimiquement modifié:', '1515'),

                                                  ('Graisses et huiles animales, végétales ou d’origine microbienne et leurs fractions, partiellement ou totalement hydrogénées, interestérifiées, réestérifiées ou élaïdinisées, même raffinées, mais non autrement préparées:', '1516'),

                                                  ('Margarine; mélanges ou préparations alimentaires de graisses ou d''huiles animales, végétales ou d’origine microbienne ou de fractions de différentes graisses ou huiles du présent chapitre, autres que les graisses et huiles alimentaires et leurs fractions du no 1516 :', '1517'),

                                                  ('Graisses et huiles animales, végétales ou d’origine microbienne et leurs fractions, cuites, oxydées, déshydratées, sulfurées, soufflées, standolisées ou autrement modifiées chimiquement, à l''exclusion de celles du no 1516 ; mélanges ou préparations non alimentaires de graisses ou d''huiles animales, végétales ou d’origine microbienne ou de fractions de différentes graisses ou huiles du présent chapitre, non dénommés ni compris ailleurs:', '1518'),

                                                  ('Glycérol brut; eaux et lessives glycérineuses', '1520'),

                                                  ('Cires végétales (autres que les triglycérides), cires d''abeilles ou d''autres insectes et spermaceti, même raffinés ou colorés:', '1521'),

                                                  ('Dégras; résidus provenant du traitement des corps gras ou des cires animales ou végétales:', '1522'),

                                                  ('Saucisses, saucissons et produits similaires, de viande, d’abats, de sang ou d’insectes; préparations alimentaires à base de ces produits:', '1601'),

                                                  ('Autres preparations et conserves de viande, d’abats, de sang ou d’insectes:', '1602'),

                                                  ('Extraits et jus de viande, de poissons ou de crustacés, de mollusques ou d''autres invertébrés aquatiques:', '1603'),

                                                  ('Préparations et conserves de poissons; caviar et ses succédanés préparés à partir d''œufs de poisson:', '1604'),

                                                  ('Crustacés, mollusques et autres invertébrés aquatiques, préparés ou conservés:', '1605'),

                                                  ('Sucres de canne ou de betterave et saccharose chimiquement pur, à l''état solide:', '1701'),

                                                  ('Autres sucres, y compris le lactose, le maltose, le glucose et le fructose (lévulose) chimiquement purs, à l''état solide; sirops de sucres sans addition d''aromatisants ou de colorants; succédanés du miel, même mélangés de miel naturel; sucres et mélasses caramélisés:', '1702'),

                                                  ('Mélasses résultant de l''extraction ou du raffinage du sucre:', '1703'),

                                                  ('Sucreries sans cacao (y compris le chocolat blanc):', '1704'),

                                                  ('Cacao en fèves et brisures de fèves, bruts ou torréfiés', '1801'),

                                                  ('Coques, pellicules (pelures) et autres déchets de cacao', '1802'),

                                                  ('Pâte de cacao, même dégraissée:', '1803'),

                                                  ('Beurre, graisse et huile de cacao', '1804'),

                                                  ('Poudre de cacao, sans addition de sucre ou d''autres édulcorants', '1805'),

                                                  ('Chocolat et autres préparations alimentaires contenant du cacao:', '1806'),

                                                  ('Extraits de malt; préparations alimentaires de farines, gruaux, semoules, amidons, fécules ou extraits de malt, ne contenant pas de cacao ou contenant moins de 40 % en poids de cacao calculés sur une base entièrement dégraissée, non dénommées ni comprises ailleurs; préparations alimentaires de produits des nos 0401  à 0404 , ne contenant pas de cacao ou contenant moins de 5 % en poids de cacao calculés sur une base entièrement dégraissée, non dénommées ni comprises ailleurs:', '1901'),

                                                  ('Pâtes alimentaires, même cuites ou farcies (de viande ou d''autres substances) ou bien autrement préparées, telles que spaghetti, macaroni, nouilles, lasagnes, gnocchi, ravioli, cannelloni; couscous, même préparé:', '1902'),

                                                  ('Tapioca et ses succédanés préparés à partir de fécules, sous forme de flocons, grumeaux, grains perlés, criblures ou formes similaires', '1903'),

                                                  ('Produits à base de céréales obtenus par soufflage ou grillage (corn flakes, par exemple); céréales (autres que le maïs) en grains ou sous forme de flocons ou d''autres grains travaillés (à l''exception de la farine, du gruau et de la semoule), précuites ou autrement préparées, non dénommées ni comprises ailleurs:', '1904'),

                                                  ('Produits de la boulangerie, de la pâtisserie ou de la biscuiterie, même additionnés de cacao; hosties, cachets vides des types utilisés pour médicaments, pains à cacheter, pâtes séchées de farine, d''amidon ou de fécule en feuilles et produits similaires:', '1905'),

                                                  ('Légumes, fruits et autres parties comestibles de plantes, préparés ou conservés au vinaigre ou à l''acide acétique:', '2001'),

                                                  ('Tomates préparées ou conservées autrement qu''au vinaigre ou à l''acide acétique:', '2002'),

                                                  ('Champignons et truffes, préparés ou conservés autrement qu''au vinaigre ou à l''acide acétique:', '2003'),

                                                  ('Autres légumes préparés ou conservés autrement qu''au vinaigre ou à l''acide acétique, congelés, autres que les produits du no 2006 :', '2004'),

                                                  ('Autres légumes préparés ou conservés autrement qu''au vinaigre ou à l''acide acétique, non congelés, autres que les produits du no 2006 :', '2005'),

                                                  ('Légumes, fruits, écorces de fruits et autres parties de plantes, confits au sucre (égouttés, glacés ou cristallisés):', '2006'),

                                                  ('Confitures, gelées, marmelades, purées et pâtes de fruits, obtenues par cuisson, avec ou sans addition de sucre ou d''autres édulcorants:', '2007'),

                                                  ('Fruits et autres parties comestibles de plantes, autrement préparés ou conservés, avec ou sans addition de sucre ou d''autres édulcorants ou d''alcool, non dénommés ni compris ailleurs:', '2008'),

                                                  ('Jus de fruits (y compris les moûts de raisin et l’eau de noix de coco) ou de légumes, non fermentés, sans addition d’alcool, avec ou sans addition de sucre ou d''autres édulcorants:', '2009'),

                                                  ('Extraits, essences et concentrés de café, de thé ou de maté et préparations à base de ces produits ou à base de café, thé ou maté; chicorée torréfiée et autres succédanés torréfiés du café et leurs extraits, essences et concentrés:', '2101'),

                                                  ('Levures (vivantes ou mortes); autres micro-organismes monocellulaires morts (à l''exclusion des vaccins du no 3002 ); poudres à lever préparées:', '2102'),

                                                  ('Préparations pour sauces et sauces préparées; condiments et assaisonnements, composés; farine de moutarde et moutarde préparée:', '2103'),

                                                  ('Préparations pour soupes, potages ou bouillons; soupes, potages ou bouillons préparés; préparations alimentaires composites homogénéisées:', '2104'),

                                                  ('Glaces de consommation, même contenant du cacao:', '2105'),

                                                  ('Préparations alimentaires non dénommées ni comprises ailleurs:', '2106'),

                                                  ('Eaux, y compris les eaux minérales naturelles ou artificielles et les eaux gazéifiées, non additionnées de sucre ou d''autres édulcorants ni aromatisées; glace et neige:', '2201'),

                                                  ('Eaux, y compris les eaux minérales et les eaux gazéifiées, additionnées de sucre ou d''autres édulcorants ou aromatisées, et autres boissons non alcooliques, à l''exclusion des jus de fruits ou de légumes du no 2009 :', '2202'),

                                                  ('Bières de malt:', '2203'),

                                                  ('Vins de raisins frais, y compris les vins enrichis en alcool; moûts de raisin, autres que ceux du no 2009 :', '2204'),

                                                  ('Vermouths et autres vins de raisins frais préparés à l''aide de plantes ou de substances aromatiques:', '2205'),

                                                  ('Autres boissons fermentées (cidre, poiré, hydromel, saké, par exemple); mélanges de boissons fermentées et mélanges de boissons fermentées et de boissons non alcooliques, non dénommés ni compris ailleurs:', '2206'),

                                                  ('Alcool éthylique non dénaturé d''un titre alcoométrique volumique de 80 % vol ou plus; alcool éthylique et eaux-de-vie dénaturés de tous titres:', '2207'),

                                                  ('Alcool éthylique non dénaturé d''un titre alcoométrique volumique de moins de 80 % vol; eaux-de-vie, liqueurs et autres boissons spiritueuses:', '2208'),

                                                  ('Vinaigres comestibles et succédanés de vinaigre comestibles obtenus à partir d''acide acétique:', '2209'),

                                                  ('Farines, poudres et agglomérés sous forme de pellets, de viandes, d''abats, de poissons ou de crustacés, de mollusques ou d''autres invertébrés aquatiques, impropres à l''alimentation humaine; cretons:', '2301'),

                                                  ('Sons, remoulages et autres résidus, même agglomérés sous forme de pellets, du criblage, de la mouture ou d''autres traitements des céréales ou des légumineuses:', '2302'),

                                                  ('Résidus d''amidonnerie et résidus similaires, pulpes de betteraves, bagasses de cannes à sucre et autres déchets de sucrerie, drêches et déchets de brasserie ou de distillerie, même agglomérés sous forme de pellets:', '2303'),

                                                  ('Tourteaux et autres résidus solides, même broyés ou agglomérés sous forme de pellets, de l''extraction de l''huile de soja', '2304'),

                                                  ('Tourteaux et autres résidus solides, même broyés ou agglomérés sous forme de pellets, de l''extraction de l''huile d''arachide', '2305'),

                                                  ('Tourteaux et autres résidus solides, même broyés ou agglomérés sous forme de pellets, de l''extraction de graisses ou huiles végétales ou d’origine microbienne, autres que ceux des nos 2304  ou 2305 :', '2306'),

                                                  ('Lies de vin; tartre brut:', '2307'),

                                                  ('Matières végétales et déchets végétaux, résidus et sous-produits végétaux, même agglomérés sous forme de pellets, des types utilisés pour l''alimentation des animaux, non dénommés ni compris ailleurs:', '2308'),

                                                  ('Préparations des types utilisés pour l''alimentation des animaux:', '2309'),

                                                  ('Tabacs bruts ou non fabriqués; déchets de tabac:', '2401'),

                                                  ('Cigares (y compris ceux à bouts coupés), cigarillos et cigarettes, en tabac ou en succédanés de tabac:', '2402'),

                                                  ('Autres tabacs et succédanés de tabac, fabriqués; tabacs «homogénéisés» ou «reconstitués»; extraits et sauces de tabac:', '2403'),

                                                  ('Produits contenant du tabac, du tabac reconstitué, de la nicotine ou des succédanés de tabac ou de nicotine, destinés à une inhalation sans combustion; autres produits contenant de la nicotine, destines à l’absorption de la nicotine dans le corps humain:', '2404'),

                                                  ('Sel (y compris le sel préparé pour la table et le sel dénaturé) et chlorure de sodium pur, même en solution aqueuse ou additionnés d''agents antiagglomérants ou d''agents assurant une bonne fluidité; eau de mer:', '2501'),

                                                  ('Pyrites de fer non grillées', '2502'),

                                                  ('Soufres de toute espèce, à l''exclusion du soufre sublimé, du soufre précipité et du soufre colloïdal:', '2503'),

                                                  ('Graphite naturel:', '2504'),

                                                  ('Sables naturels de toute espèce, même colorés, à l''exclusion des sables métallifères du chapitre 26:', '2505'),

                                                  ('Quartz (autres que les sables naturels); quartzites, même dégrossis ou simplement débités, par sciage ou autrement, en blocs ou en plaques de forme carrée ou rectangulaire:', '2506'),

                                                  ('Kaolin et autres argiles kaoliniques, même calcinés:', '2507'),

                                                  ('Autres argiles (à l''exclusion des argiles expansées du no 6806 ), andalousite, cyanite, sillimanite, même calcinées; mullite; terres de chamotte ou de dinas:', '2508'),

                                                  ('Craie', '2509'),

                                                  ('Phosphates de calcium naturels, phosphates aluminocalciques naturels et craies phosphatées:', '2510'),

                                                  ('Sulfate de baryum naturel (barytine); carbonate de baryum naturel (withérite), même calciné, à l''exclusion de l''oxyde de baryum du no 2816 :', '2511'),

                                                  ('Farines siliceuses fossiles (kieselguhr, tripolite, diatomite, par exemple) et autres terres siliceuses analogues, d''une densité apparente n''excédant pas 1, même calcinées', '2512'),

                                                  ('Pierre ponce; émeri; corindon naturel, grenat naturel et autres abrasifs naturels, même traités thermiquement:', '2513'),

                                                  ('Ardoise, même dégrossie ou simplement débitée, par sciage ou autrement, en blocs ou en plaques de forme carrée ou rectangulaire', '2514'),

                                                  ('Marbres, travertins, écaussines et autres pierres calcaires de taille ou de construction d''une densité apparente égale ou supérieure à 2,5, et albâtre, même dégrossis ou simplement débités, par sciage ou autrement, en blocs ou en plaques de forme carrée ou rectangulaire:', '2515'),

                                                  ('Granit, porphyre, basalte, grès et autres pierres de taille ou de construction, même dégrossis ou simplement débités, par sciage ou autrement, en blocs ou en plaques de forme carrée ou rectangulaire:', '2516'),

                                                  ('Cailloux, graviers, pierres concassées, des types généralement utilisés pour le bétonnage ou pour l''empierrement des routes, des voies ferrées ou autres ballasts, galets et silex, même traités thermiquement; macadam de laitier, de scories ou de déchets industriels similaires, même comprenant des matières reprises dans la première partie du libellé; tarmacadam; granulés, éclats et poudres de pierres des nos 2515  ou 2516 , même traités thermiquement:', '2517'),

                                                  ('Dolomie, même frittée ou calcinée, y compris la dolomie dégrossie ou simplement débitée, par sciage ou autrement, en blocs ou en plaques de forme carrée ou rectangulaire:', '2518'),

                                                  ('Carbonate de magnésium naturel (magnésite); magnésie électrofondue; magnésie calcinée à mort (frittée), même contenant de faibles quantités d''autres oxydes ajoutés avant le frittage; autre oxyde de magnésium, même pur:', '2519'),

                                                  ('Gypse; anhydrite; plâtres, même colorés ou additionnés de faibles quantités d''accélérateurs ou de retardateurs:', '2520'),

                                                  ('Castines; pierres à chaux ou à ciment', '2521'),

                                                  ('Chaux vive, chaux éteinte et chaux hydraulique, à l''exclusion de l''oxyde et de l''hydroxyde de calcium du no 2825 :', '2522'),

                                                  ('Ciments hydrauliques (y compris les ciments non pulvérisés dits «clinkers»), même colorés:', '2523'),

                                                  ('Amiante (asbeste):', '2524'),

                                                  ('Mica, y compris le mica clivé en lamelles irrégulières (splittings); déchets de mica:', '2525'),

                                                  ('Stéatite naturelle, même dégrossie ou simplement débitée, par sciage ou autrement, en blocs ou en plaques de forme carrée ou rectangulaire; talc:', '2526'),

                                                  ('Borates naturels et leurs concentrés (calcinés ou non), à l''exclusion des borates extraits des saumures naturelles; acide borique naturel titrant au maximum 85 % de H3BO3 sur produit sec', '2528'),

                                                  ('Feldspath; leucite; néphéline et néphéline syénite; spath fluor:', '2529'),

                                                  ('Matières minérales non dénommées ni comprises ailleurs:', '2530'),

                                                  ('Minerais de fer et leurs concentrés, y compris les pyrites de fer grillées (cendres de pyrites):', '2601'),

                                                  ('Minerais de manganèse et leurs concentrés, y compris les minerais de manganèse ferrugineux et leurs concentrés d''une teneur en manganèse de 20 % ou plus en poids, sur produit sec', '2602'),

                                                  ('Minerais de cuivre et leurs concentrés', '2603'),

                                                  ('Minerais de nickel et leurs concentrés', '2604'),

                                                  ('Minerais de cobalt et leurs concentrés', '2605'),

                                                  ('Minerais d''aluminium et leurs concentrés', '2606'),

                                                  ('Minerais de plomb et leurs concentrés', '2607'),

                                                  ('Minerais de zinc et leurs concentrés', '2608'),

                                                  ('Minerais d''étain et leurs concentrés', '2609'),

                                                  ('Minerais de chrome et leurs concentrés', '2610'),

                                                  ('Minerais de tungstène et leurs concentrés', '2611'),

                                                  ('Minerais d''uranium ou de thorium et leurs concentrés:', '2612'),

                                                  ('Minerais de molybdène et leurs concentrés:', '2613'),

                                                  ('Minerais de titane et leurs concentrés', '2614'),

                                                  ('Minerais de niobium, de tantale, de vanadium ou de zirconium et leurs concentrés:', '2615'),

                                                  ('Minerais de métaux précieux et leurs concentrés:', '2616'),

                                                  ('Autres minerais et leurs concentrés:', '2617'),

                                                  ('Laitier granulé (sable-laitier) provenant de la fabrication de la fonte, du fer ou de l''acier', '2618'),

                                                  ('Scories, laitiers (autres que le laitier granulé), battitures et autres déchets de la fabrication de la fonte, du fer ou de l''acier:', '2619'),

                                                  ('Scories, cendres et résidus (autres que ceux provenant de la fabrication de la fonte, du fer ou de l''acier) contenant des métaux, de l''arsenic, ou leurs composés:', '2620'),

                                                  ('Autres scories et cendres, y compris les cendres de varech; cendres et résidus provenant de l''incinération des déchets municipaux:', '2621'),

                                                  ('Houilles; briquettes, boulets et combustibles solides similaires obtenus à partir de la houille:', '2701'),

                                                  ('Lignites, même agglomérés, à l''exclusion du jais:', '2702'),

                                                  ('Tourbe (y compris la tourbe pour litière), même agglomérée', '2703'),

                                                  ('Cokes et semi-cokes de houille, de lignite ou de tourbe, même agglomérés; charbon de cornue:', '2704'),

                                                  ('Gaz de houille, gaz à l''eau, gaz pauvre et gaz similaires, à l''exclusion des gaz de pétrole et autres hydrocarbures gazeux', '2705'),

                                                  ('Goudrons de houille, de lignite ou de tourbe et autres goudrons minéraux, même déshydratés ou étêtés, y compris les goudrons reconstitués', '2706'),

                                                  ('Huiles et autres produits provenant de la distillation des goudrons de houille de haute température; produits analogues dans lesquels les constituants aromatiques prédominent en poids par rapport aux constituants non aromatiques:', '2707'),

                                                  ('Brai et coke de brai de goudron de houille ou d''autres goudrons minéraux:', '2708'),

                                                  ('Huiles brutes de pétrole ou de minéraux bitumineux:', '2709'),

                                                  ('Huiles de pétrole ou de minéraux bitumineux, autres que les huiles brutes; préparations non dénommées ni comprises ailleurs, contenant en poids 70 % ou plus d''huiles de pétrole ou de minéraux bitumineux et dont ces huiles constituent l''élément de base; déchets d''huiles:', '2710'),

                                                  ('Gaz de pétrole et autres hydrocarbures gazeux:', '2711'),

                                                  ('Vaseline; paraffine, cire de pétrole microcristalline, slack wax, ozokérite, cire de lignite, cire de tourbe, autres cires minérales et produits similaires obtenus par synthèse ou par d''autres procédés, même colorés:', '2712'),

                                                  ('Coke de pétrole, bitume de pétrole et autres résidus des huiles de pétrole ou de minéraux bitumineux:', '2713'),

                                                  ('Bitumes et asphaltes, naturels; schistes et sables bitumineux; asphaltites et roches asphaltiques:', '2714'),

                                                  ('Mélanges bitumineux à base d''asphalte ou de bitume naturels, de bitume de pétrole, de goudron minéral ou de brai de goudron minéral (mastics bitumineux, cut-backs, par exemple)', '2715'),

                                                  ('Énergie électrique', '2716'),

                                                  ('Fluor, chlore, brome et iode:', '2801'),

                                                  ('Soufre sublimé ou précipité; soufre colloïdal', '2802'),

                                                  ('Carbone (noirs de carbone et autres formes de carbone non dénommées ni comprises ailleurs)', '2803'),

                                                  ('Hydrogène, gaz rares et autres éléments non métalliques:', '2804'),

                                                  ('Métaux alcalins ou alcalino-terreux; métaux de terres rares, scandium et yttrium, même mélangés ou alliés entre eux; mercure:', '2805'),

                                                  ('Chlorure d''hydrogène (acide chlorhydrique); acide chlorosulfurique:', '2806'),

                                                  ('Acide sulfurique; oléum', '2807'),

                                                  ('Acide nitrique; acides sulfonitriques', '2808'),

                                                  ('Pentaoxyde de diphosphore; acide phosphorique; acides polyphosphoriques, de constitution chimique définie ou non:', '2809'),

                                                  ('Oxydes de bore; acides boriques:', '2810'),

                                                  ('Autres acides inorganiques et autres composés oxygénés inorganiques des éléments non métalliques:', '2811'),

                                                  ('Halogénures et oxyhalogénures des éléments non métalliques:', '2812'),

                                                  ('Sulfures des éléments non métalliques; trisulfure de phosphore du commerce:', '2813'),

                                                  ('Ammoniac anhydre ou en solution aqueuse (ammoniaque):', '2814'),

                                                  ('Hydroxyde de sodium (soude caustique); hydroxyde de potassium (potasse caustique); peroxydes de sodium ou de potassium:', '2815'),

                                                  ('Hydroxyde et peroxyde de magnésium; oxydes, hydroxydes et peroxydes de strontium ou de baryum:', '2816'),

                                                  ('Oxyde de zinc; peroxyde de zinc', '2817'),

                                                  ('Corindon artificiel, chimiquement défini ou non; oxyde d''aluminium; hydroxyde d''aluminium:', '2818'),

                                                  ('Oxydes et hydroxydes de chrome:', '2819'),

                                                  ('Oxydes de manganèse:', '2820'),

                                                  ('Oxydes et hydroxydes de fer; terres colorantes contenant en poids 70 % ou plus de fer combiné, évalué en Fe2O3:', '2821'),

                                                  ('Oxydes et hydroxydes de cobalt; oxydes de cobalt du commerce', '2822'),

                                                  ('Oxydes de titane', '2823'),

                                                  ('Oxydes de plomb; minium et mine orange:', '2824'),

                                                  ('Hydrazine et hydroxylamine et leurs sels inorganiques; autres bases inorganiques; autres oxydes, hydroxydes et peroxydes de métaux:', '2825'),

                                                  ('Fluorures; fluorosilicates, fluoroaluminates et autres sels complexes de fluor:', '2826'),

                                                  ('Chlorures, oxychlorures et hydroxychlorures; bromures et oxybromures; iodures et oxyiodures:', '2827'),

                                                  ('Hypochlorites; hypochlorite de calcium du commerce; chlorites; hypobromites:', '2828'),

                                                  ('Chlorates et perchlorates; bromates et perbromates; iodates et periodates:', '2829'),

                                                  ('Sulfures; polysulfures, de constitution chimique définie ou non:', '2830'),

                                                  ('Dithionites et sulfoxylates:', '2831'),

                                                  ('Sulfites; thiosulfates:', '2832'),

                                                  ('Sulfates; aluns; peroxosulfates (persulfates):', '2833'),

                                                  ('Nitrites; nitrates:', '2834'),

                                                  ('Phosphinates (hypophosphites), phosphonates (phosphites) et phosphates; polyphosphates, de constitution chimique définie ou non:', '2835'),

                                                  ('Carbonates; peroxocarbonates (percarbonates); carbonate d''ammonium du commerce contenant du carbamate d''ammonium:', '2836'),

                                                  ('Cyanures, oxycyanures et cyanures complexes:', '2837'),

                                                  ('Silicates; silicates des métaux alcalins du commerce:', '2839'),

                                                  ('Borates; peroxoborates (perborates):', '2840'),

                                                  ('Sels des acides oxométalliques ou peroxométalliques:', '2841'),

                                                  ('Autres sels des acides ou peroxoacides inorganiques (y compris les aluminosilicates de constitution chimique définie ou non), autres que les azotures:', '2842'),

                                                  ('Métaux précieux à l''état colloïdal; composés inorganiques ou organiques de métaux précieux, de constitution chimique définie ou non; amalgames de métaux précieux:', '2843'),

                                                  ('Éléments chimiques radioactifs et isotopes radioactifs (y compris les éléments chimiques et isotopes fissiles ou fertiles) et leurs composés; mélanges et résidus contenant ces produits:', '2844'),

                                                  ('Isotopes autres que ceux du no 2844 ; leurs composés inorganiques ou organiques, de constitution chimique définie ou non:', '2845'),

                                                  ('Composés, inorganiques ou organiques, des métaux des terres rares, de l''yttrium ou du scandium ou des mélanges de ces métaux:', '2846'),

                                                  ('Peroxyde d''hydrogène (eau oxygénée) même solidifié avec de l''urée', '2847'),

                                                  ('Carbures, de constitution chimique définie ou non:', '2849'),

                                                  ('Hydrures, nitrures, azotures, siliciures et borures, de constitution chimique définie ou non, autres que les composés qui constituent également des carbures du no 2849 :', '2850'),

                                                  ('Composés inorganiques ou organiques du mercure, de constitution chimique définie ou non, à l''exclusion des amalgames:', '2852'),

                                                  ('Phosphures, de constitution chimique définie ou non, à l’exclusion des ferrophosphores; autres composés inorganiques (y compris les eaux distillées, de conductibilité ou de même degré de pureté); air liquide (y compris l’air liquide dont les gaz rares ont été éliminés); air comprimé; amalgames autres que de métaux précieux:', '2853'),

                                                  ('Hydrocarbures acycliques:', '2901'),

                                                  ('Hydrocarbures cycliques:', '2902'),

                                                  ('Dérivés halogénés des hydrocarbures:', '2903'),

                                                  ('Dérivés sulfonés, nitrés ou nitrosés des hydrocarbures, même halogénés:', '2904'),

                                                  ('Alcools acycliques et leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2905'),

                                                  ('Alcools cycliques et leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2906'),

                                                  ('Phénols; phénols-alcools:', '2907'),

                                                  ('Dérivés halogénés, sulfonés, nitrés ou nitrosés des phénols ou des phénols-alcools:', '2908'),

                                                  ('Éthers, éthers-alcools, éthers-phénols, éthers-alcools-phénols, peroxydes d''alcools, peroxydes d''éthers, peroxydes d’acétals et d’hémi-acetals, peroxydes de cétones (de constitution chimique définie ou non) et leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2909'),

                                                  ('Époxydes, époxy-alcools, époxy-phénols et époxy-éthers, avec trois atomes dans le cycle, et leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2910'),

                                                  ('Acétals et hémi-acétals, même contenant d''autres fonctions oxygénées, et leurs dérivés halogénés, sulfonés, nitrés ou nitrosés', '2911'),

                                                  ('Aldéhydes, même contenant d''autres fonctions oxygénées; polymères cycliques des aldéhydes; paraformaldéhyde:', '2912'),

                                                  ('Dérivés halogénés, sulfonés, nitrés ou nitrosés des produits du no 2912', '2913'),

                                                  ('Cétones et quinones, même contenant d''autres fonctions oxygénées, et leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2914'),

                                                  ('Acides monocarboxyliques acycliques saturés et leurs anhydrides, halogénures, peroxydes et peroxyacides; leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2915'),

                                                  ('Acides monocarboxyliques acycliques non saturés et acides monocarboxyliques cycliques, leurs anhydrides, halogénures, peroxydes et peroxyacides; leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2916'),

                                                  ('Acides polycarboxyliques, leurs anhydrides, halogénures, peroxydes et peroxyacides; leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2917'),

                                                  ('Acides carboxyliques contenant des fonctions oxygénées supplémentaires et leurs anhydrides, halogénures, peroxydes et peroxyacides; leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2918'),

                                                  ('Esters phosphoriques et leurs sels, y compris les lactophosphates; leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2919'),

                                                  ('Esters des autres acides inorganiques des non-métaux (à l''exclusion des esters des halogénures d''hydrogène) et leurs sels; leurs dérivés halogénés, sulfonés, nitrés ou nitrosés:', '2920'),

                                                  ('Composés à fonction amine:', '2921'),

                                                  ('Composés aminés à fonctions oxygénées:', '2922'),

                                                  ('Sels et hydroxydes d''ammonium quaternaires; lécithines et autres phosphoaminolipides, de constitution chimique définie ou non:', '2923'),

                                                  ('Composés à fonction carboxyamide; composés à fonction amide de l''acide carbonique:', '2924'),

                                                  ('Composés à fonction carboxyimide (y compris la saccharine et ses sels) ou à fonction imine:', '2925'),

                                                  ('Composés à fonction nitrile:', '2926'),

                                                  ('Composés diazoïques, azoïques ou azoxyques', '2927'),

                                                  ('Dérivés organiques de l''hydrazine ou de l''hydroxylamine:', '2928'),

                                                  ('Composés à autres fonctions azotées:', '2929'),

                                                  ('Thiocomposés organiques:', '2930'),

                                                  ('Autres composés organo-inorganiques:', '2931'),

                                                  ('Composés hétérocycliques à hétéroatome(s) d''oxygène exclusivement:', '2932'),

                                                  ('Composés hétérocycliques à hétéroatome(s) d''azote exclusivement:', '2933'),

                                                  ('Acides nucléiques et leurs sels, de constitution chimique définie ou non; autres composés hétérocycliques:', '2934'),

                                                  ('Sulfonamides:', '2935'),

                                                  ('Provitamines et vitamines, naturelles ou reproduites par synthèse (y compris les concentrats naturels), ainsi que leurs dérivés utilisés principalement en tant que vitamines, mélangés ou non entre eux, même en solutions quelconques:', '2936'),

                                                  ('Hormones, prostaglandines, thromboxanes et leucotriènes, naturels ou reproduits par synthèse; leurs dérivés et analogues structurels, y compris les polypeptides à chaîne modifiée, utilisés principalement comme hormones:', '2937'),

                                                  ('Hétérosides, naturels ou reproduits par synthèse, leurs sels, leurs éthers, leurs esters et autres dérivés:', '2938'),

                                                  ('Alcaloïdes, naturels ou reproduits par synthèse, leurs sels, leurs éthers, leurs esters et autres dérivés:', '2939'),

                                                  ('Sucres chimiquement purs, à l''exception du saccharose, du lactose, du maltose, du glucose et du fructose (lévulose); éthers, acétals et esters de sucres et leurs sels, autres que les produits des nos 2937 , 2938  et 2939', '2940'),

                                                  ('Antibiotiques:', '2941'),

                                                  ('Autres composés organiques', '2942'),

                                                  ('Glandes et autres organes à usages opothérapiques, à l''état desséché, même pulvérisés; extraits, à usages opothérapiques, de glandes ou d''autres organes ou de leurs sécrétions; héparine et ses sels; autres substances humaines ou animales préparées à des fins thérapeutiques ou prophylactiques non dénommées ni comprises ailleurs:', '3001'),

                                                  ('Sang humain; sang animal préparé en vue d’usages thérapeutiques, prophylactiques ou de diagnostic; antisérums, autres fractions du sang et produits immunologiques, même modifiés ou obtenus par voie biotechnologique; vaccins, toxines, cultures de micro-organismes (à l’exclusion des levures) et produits similaires; cultures de cellules, même modifiées:', '3002'),

                                                  ('Médicaments (à l''exclusion des produits des nos 3002 , 3005  ou 3006 ) constitués par des produits mélangés entre eux, préparés à des fins thérapeutiques ou prophylactiques, mais ni présentés sous forme de doses, ni conditionnés pour la vente au détail:', '3003'),

                                                  ('Médicaments (à l''exclusion des produits des nos 3002 , 3005  ou 3006 ) constitués par des produits mélangés ou non mélangés, préparés à des fins thérapeutiques ou prophylactiques, présentés sous forme de doses (y compris ceux destinés à être administrés par voie percutanée) ou conditionnés pour la vente au détail:', '3004'),

                                                  ('Ouates, gazes, bandes et articles analogues (pansements, sparadraps, sinapismes, par exemple), imprégnés ou recouverts de substances pharmaceutiques ou conditionnés pour la vente au détail à des fins médicales, chirurgicales, dentaires ou vétérinaires:', '3005'),

                                                  ('Préparations et articles pharmaceutiques visés à la note 4 du présent chapitre:', '3006'),

                                                  ('Engrais d''origine animale ou végétale, même mélangés entre eux ou traités chimiquement; engrais résultant du mélange ou du traitement chimique de produits d''origine animale ou végétale', '3101'),

                                                  ('Engrais minéraux ou chimiques azotés:', '3102'),

                                                  ('Engrais minéraux ou chimiques phosphatés:', '3103'),

                                                  ('Engrais minéraux ou chimiques potassiques:', '3104'),

                                                  ('Engrais minéraux ou chimiques contenant deux ou trois des éléments fertilisants: azote, phosphore et potassium; autres engrais; produits du présent chapitre présentés soit en tablettes ou formes similaires, soit en emballages d''un poids brut n''excédant pas 10 kg:', '3105'),

                                                  ('Extraits tannants d''origine végétale; tanins et leurs sels, éthers, esters et autres dérivés:', '3201'),

                                                  ('Produits tannants organiques synthétiques; produits tannants inorganiques; préparations tannantes, même contenant des produits tannants naturels; préparations enzymatiques pour le prétannage:', '3202'),

                                                  ('Matières colorantes d''origine végétale ou animale (y compris les extraits tinctoriaux, mais à l''exclusion des noirs d''origine animale), même de constitution chimique définie; préparations visées à la note 3 du présent chapitre, à base de matières colorantes d''origine végétale ou animale:', '3203'),

                                                  ('Matières colorantes organiques synthétiques, même de constitution chimique définie; préparations visées à la note 3 du présent chapitre, à base de matières colorantes organiques synthétiques; produits organiques synthétiques des types utilisés comme agents d''avivage fluorescents ou comme luminophores, même de constitution chimique définie:', '3204'),

                                                  ('Laques colorantes; préparations visées à la note 3 du présent chapitre, à base de laques colorantes', '3205'),

                                                  ('Autres matières colorantes; préparations visées à la note 3 du présent chapitre, autres que celles des nos 3203 , 3204  ou 3205 ; produits inorganiques des types utilisés comme luminophores, même de constitution chimique définie:', '3206'),

                                                  ('Pigments, opacifiants et couleurs préparés, compositions vitrifiables, engobes, lustres liquides et préparations similaires, des types utilisés pour la céramique, l''émaillerie ou la verrerie; frittes de verre et autres verres, sous forme de poudre, de grenailles, de lamelles ou de flocons:', '3207'),

                                                  ('Peintures et vernis à base de polymères synthétiques ou de polymères naturels modifiés, dispersés ou dissous dans un milieu non aqueux; solutions définies à la note 4 du présent chapitre:', '3208'),

                                                  ('Peintures et vernis à base de polymères synthétiques ou de polymères naturels modifiés, dispersés ou dissous dans un milieu aqueux:', '3209'),

                                                  ('Autres peintures et vernis; pigments à l''eau préparés des types utilisés pour le finissage des cuirs:', '3210'),

                                                  ('Siccatifs préparés', '3211'),

                                                  ('Pigments (y compris les poudres et flocons métalliques) dispersés dans des milieux non aqueux, sous forme de liquide ou de pâte, des types utilisés pour la fabrication de peintures; feuilles pour le marquage au fer; teintures et autres matières colorantes présentées dans des formes ou emballages pour la vente au détail:', '3212'),

                                                  ('Couleurs pour la peinture artistique, l''enseignement, la peinture des enseignes, la modification des nuances, l''amusement et couleurs similaires, en pastilles, tubes, pots, flacons, godets ou conditionnements similaires:', '3213'),

                                                  ('Mastic de vitrier, ciments de résine et autres mastics; enduits utilisés en peinture; enduits non réfractaires des types utilisés en maçonnerie:', '3214'),

                                                  ('Encres d''imprimerie, encres à écrire ou à dessiner et autres encres, même concentrées ou sous formes solides:', '3215'),

                                                  ('Huiles essentielles (déterpénées ou non), y compris celles dites «concrètes» ou «absolues»; résinoïdes; oléorésines d''extraction; solutions concentrées d''huiles essentielles dans les graisses, les huiles fixes, les cires ou matières analogues, obtenues par enfleurage ou macération; sous-produits terpéniques résiduaires de la déterpénation des huiles essentielles; eaux distillées aromatiques et solutions aqueuses d''huiles essentielles:', '3301'),

                                                  ('Mélanges de substances odoriférantes et mélanges (y compris les solutions alcooliques) à base d''une ou de plusieurs de ces substances, des types utilisés comme matières de base pour l''industrie; autres préparations à base de substances odoriférantes, des types utilisés pour la fabrication de boissons:', '3302'),

                                                  ('Parfums et eaux de toilette:', '3303'),

                                                  ('Produits de beauté ou de maquillage préparés et préparations pour l''entretien ou les soins de la peau, autres que les médicaments, y compris les préparations antisolaires et les préparations pour bronzer; préparations pour manucures ou pédicures:', '3304'),

                                                  ('Préparations capillaires:', '3305'),

                                                  ('Préparations pour l''hygiène buccale ou dentaire, y compris les poudres et crèmes pour faciliter l''adhérence des dentiers; fils utilisés pour nettoyer les espaces interdentaires (fils dentaires), en emballages individuels de détail:', '3306'),

                                                  ('Préparations pour le prérasage, le rasage ou l''après-rasage, désodorisants corporels, préparations pour bains, dépilatoires, autres produits de parfumerie ou de toilette préparés et autres préparations cosmétiques, non dénommés ni compris ailleurs; désodorisants de locaux, préparés, même non parfumés, ayant ou non des propriétés désinfectantes:', '3307'),

                                                  ('Savons; produits et préparations organiques tensio-actifs à usage de savon, en barres, en pains, en morceaux ou en sujets frappés, même contenant du savon; produits et préparations organiques tensio-actifs destinés au lavage de la peau, sous forme de liquide ou de crème, conditionnés pour la vente au détail, même contenant du savon; papier, ouates, feutres et nontissés, imprégnés, enduits ou recouverts de savon ou de détergents:', '3401'),

                                                  ('Agents de surface organiques (autres que les savons); préparations tensio-actives, préparations pour lessives (y compris les préparations auxiliaires de lavage) et préparations de nettoyage, même contenant du savon, autres que celles du no 3401 :', '3402'),

                                                  ('Préparations lubrifiantes (y compris les huiles de coupe, les préparations pour le dégrippage des écrous, les préparations antirouille ou anticorrosion et les préparations pour le démoulage, à base de lubrifiants) et préparations des types utilisés pour l''ensimage des matières textiles, l''huilage ou le graissage du cuir, des pelleteries ou d''autres matières, à l''exclusion de celles contenant comme constituants de base 70 % ou davantage en poids d''huiles de pétrole ou de minéraux bitumineux:', '3403'),

                                                  ('Cires artificielles et cires préparées:', '3404'),

                                                  ('Cirages et crèmes pour chaussures, encaustiques, brillants pour carrosseries, verre ou métaux, pâtes et poudres à récurer et préparations similaires (même sous forme de papier, ouates, feutres, nontissés, matière plastique ou caoutchouc alvéolaires, imprégnés, enduits ou recouverts de ces préparations), à l''exclusion des cires du no 3404 :', '3405'),

                                                  ('Bougies, chandelles, cierges et articles similaires', '3406'),

                                                  ('Pâtes à modeler, y compris celles présentées pour l''amusement des enfants; compositions dites «cires pour l''art dentaire» présentées en assortiments, dans des emballages de vente au détail ou en plaquettes, fers à cheval, bâtonnets ou sous des formes similaires; autres compositions pour l''art dentaire, à base de plâtre', '3407'),

                                                  ('Caséines, caséinates et autres dérivés des caséines; colles de caséine:', '3501'),

                                                  ('Albumines (y compris les concentrats de plusieurs protéines de lactosérum contenant, en poids calculé sur matière sèche, plus de 80 % de protéines de lactosérum), albuminates et autres dérivés des albumines:', '3502'),

                                                  ('Gélatines (y compris celles présentées en feuilles de forme carrée ou rectangulaire, même ouvrées en surface ou colorées) et leurs dérivés; ichtyocolle; autres colles d''origine animale, à l''exclusion des colles de caséine du no 3501 :', '3503'),

                                                  ('Peptones et leurs dérivés; autres matières protéiques et leurs dérivés, non dénommés ni compris ailleurs; poudre de peau, traitée ou non au chrome:', '3504'),

                                                  ('Dextrine et autres amidons et fécules modifiés (les amidons et fécules pré-gélatinisés ou estérifiés, par exemple); colles à base d''amidons ou de fécules, de dextrine ou d''autres amidons ou fécules modifiés:', '3505'),

                                                  ('Colles et autres adhésifs préparés, non dénommés ni compris ailleurs; produits de toute espèce à usage de colles ou d''adhésifs, conditionnés pour la vente au détail comme colles ou adhésifs, d''un poids net n''excédant pas 1 kg:', '3506'),

                                                  ('Enzymes; enzymes préparées non dénommées ni comprises ailleurs:', '3507'),

                                                  ('Poudres propulsives', '3601'),

                                                  ('Explosifs préparés autres que les poudres propulsives', '3602'),

                                                  ('Mèches de sûreté; cordeaux détonants; amorces et capsules fulminantes; allumeurs; détonateurs électriques:', '3603'),

                                                  ('Articles pour feux d''artifice, fusées de signalisation ou paragrêles et similaires, pétards et autres articles de pyrotechnie:', '3604'),

                                                  ('Allumettes, autres que les articles de pyrotechnie du no 3604', '3605'),

                                                  ('Ferrocérium et autres alliages pyrophoriques sous toutes formes; articles en matières inflammables cités à la note 2 du présent chapitre:', '3606'),

                                                  ('Plaques et films plans, photographiques, sensibilisés, non impressionnés, en autres matières que le papier, le carton ou les textiles; films photographiques plans à développement et tirage instantanés, sensibilisés, non impressionnés, même en chargeurs:', '3701'),

                                                  ('Pellicules photographiques sensibilisées, non impressionnées, en rouleaux, en autres matières que le papier, le carton ou les textiles; pellicules photographiques à développement et tirage instantanés en rouleaux, sensibilisées, non impressionnées:', '3702'),

                                                  ('Papiers, cartons et textiles, photographiques, sensibilisés, non impressionnés:', '3703'),

                                                  ('Plaques, pellicules, films, papiers, cartons et textiles, photographiques, impressionnés mais non développés:', '3704'),

                                                  ('Plaques et pellicules, photographiques, impressionnées et développées, autres que les films cinématographiques:', '3705'),

                                                  ('Films cinématographiques, impressionnés et développés, comportant ou non l''enregistrement du son ou ne comportant que l''enregistrement du son:', '3706'),

                                                  ('Préparations chimiques pour usages photographiques, autres que les vernis, colles, adhésifs et préparations similaires; produits non mélangés, soit dosés en vue d''usages photographiques, soit conditionnés pour la vente au détail pour ces mêmes usages et prêts à l''emploi:', '3707'),

                                                  ('Graphite artificiel; graphite colloïdal ou semi-colloïdal; préparations à base de graphite ou d''autre carbone, sous forme de pâtes, blocs, plaquettes ou d''autres demi-produits:', '3801'),

                                                  ('Charbons activés; matières minérales naturelles activées; noirs d''origine animale, y compris le noir animal épuisé:', '3802'),

                                                  ('Tall oil, même raffiné:', '3803'),

                                                  ('Lessives résiduaires de la fabrication des pâtes de cellulose, même concentrées, désucrées ou traitées chimiquement, y compris les lignosulfonates, mais à l''exclusion du tall oil du no 3803', '3804'),

                                                  ('Essences de térébenthine, de bois de pin ou de papeterie au sulfate et autres essences terpéniques provenant de la distillation ou d''autres traitements des bois de conifères; dipentène brut; essence de papeterie au bisulfite et autres paracymènes bruts; huile de pin contenant l''alpha-terpinéol comme constituant principal:', '3805'),

                                                  ('Colophanes et acides résiniques, et leurs dérivés; essence de colophane et huiles de colophane; gommes fondues:', '3806'),

                                                  ('Goudrons de bois; huiles de goudron de bois; créosote de bois; méthylène; poix végétales; poix de brasserie et préparations similaires à base de colophanes, d''acides résiniques ou de poix végétales:', '3807'),

                                                  ('Insecticides, antirongeurs, fongicides, herbicides, inhibiteurs de germination et régulateurs de croissance pour plantes, désinfectants et produits similaires, présentés dans des formes ou emballages de vente au détail ou à l''état de préparations ou sous forme d''articles tels que rubans, mèches et bougies soufrés et papier tue-mouches:', '3808'),

                                                  ('Agents d''apprêt ou de finissage, accélérateurs de teinture ou de fixation de matières colorantes et autres produits et préparations (parements préparés et préparations pour le mordançage, par exemple), des types utilisés dans l''industrie textile, l''industrie du papier, l''industrie du cuir ou les industries similaires, non dénommés ni compris ailleurs:', '3809'),

                                                  ('Préparations pour le décapage des métaux; flux à souder ou à braser et autres préparations auxiliaires pour le soudage ou le brasage des métaux; pâtes et poudres à souder ou à braser composées de métal et d''autres produits; préparations des types utilisés pour l''enrobage ou le fourrage des électrodes ou des baguettes de soudage:', '3810'),

                                                  ('Préparations antidétonantes, inhibiteurs d''oxydation, additifs peptisants, améliorants de viscosité, additifs anticorrosifs et autres additifs préparés, pour huiles minérales (y compris l''essence) ou pour autres liquides utilisés aux mêmes fins que les huiles minérales:', '3811'),

                                                  ('Préparations dites «accélérateurs de vulcanisation»; plastifiants composites pour caoutchouc ou matières plastiques, non dénommés ni compris ailleurs; préparations antioxydantes et autres stabilisateurs composites pour caoutchouc ou matières plastiques:', '3812'),

                                                  ('Compositions et charges pour appareils extincteurs; grenades et bombes extinctrices', '3813'),

                                                  ('Solvants et diluants organiques composites, non dénommés ni compris ailleurs; préparations conçues pour enlever les peintures ou les vernis:', '3814'),

                                                  ('Initiateurs de réaction, accélérateurs de réaction et préparations catalytiques, non dénommés ni compris ailleurs:', '3815'),

                                                  ('Ciments, mortiers, bétons et compositions similaires réfractaires y compris les pisés de dolomie, autres que les produits du no 3801 :', '3816'),

                                                  ('Alkylbenzènes en mélanges et alkylnaphtalènes en mélanges, autres que ceux des nos 2707  ou 2902 :', '3817'),

                                                  ('Éléments chimiques dopés en vue de leur utilisation en électronique, sous forme de disques, plaquettes ou formes analogues; composés chimiques dopés en vue de leur utilisation en électronique:', '3818'),

                                                  ('Liquides pour freins hydrauliques et autres liquides préparés pour transmissions hydrauliques, ne contenant pas d''huiles de pétrole ni de minéraux bitumineux ou en contenant moins de 70 % en poids', '3819'),

                                                  ('Préparations antigel et liquides préparés pour dégivrage', '3820'),

                                                  ('Milieux de culture préparés pour le développement et l''entretien des micro-organismes (y compris les virus et les organismes similaires) ou des cellules végétales, humaines ou animales', '3821'),

                                                  ('Réactifs de diagnostic ou de laboratoire sur tout support et réactifs de diagnostic ou de laboratoire préparés, même sur un support, même présentés sous forme de trousses, autres que ceux du no 3006 ; matériaux de référence certifiés:', '3822'),

                                                  ('Acides gras monocarboxyliques industriels; huiles acides de raffinage; alcools gras industriels:', '3823'),

                                                  ('Liants préparés pour moules ou noyaux de fonderie; produits chimiques et préparations des industries chimiques ou des industries connexes (y compris celles consistant en mélanges de produits naturels), non dénommés ni compris ailleurs:', '3824'),

                                                  ('Produits résiduaires des industries chimiques ou des industries connexes, non dénommés ni compris ailleurs; déchets municipaux; boues d''épuration; autres déchets mentionnés dans la note 6 du présent chapitre:', '3825'),

                                                  ('Biodiesel et ses mélanges, ne contenant pas d''huiles de pétrole ni de minéraux bitumineux ou en contenant moins de 70 % en poids:', '3826'),

                                                  ('Mélanges contenant des dérivés halogénés du méthane, de l’éthane ou du propane, non dénommés ni compris ailleurs:', '3827'),

                                                  ('Polymères de l''éthylène, sous formes primaires:', '3901'),

                                                  ('Polymères de propylène ou d''autres oléfines, sous formes primaires:', '3902'),

                                                  ('Polymères du styrène, sous formes primaires:', '3903'),

                                                  ('Polymères du chlorure de vinyle ou d''autres oléfines halogénées, sous formes primaires:', '3904'),

                                                  ('Polymères d''acétate de vinyle ou d''autres esters de vinyle, sous formes primaires; autres polymères de vinyle, sous formes primaires:', '3905'),

                                                  ('Polymères acryliques, sous formes primaires:', '3906'),

                                                  ('Polyacétals, autres polyéthers et résines époxydes, sous formes primaires; polycarbonates, résines alkydes, polyesters allyliques et autres polyesters, sous formes primaires:', '3907'),

                                                  ('Polyamides sous formes primaires:', '3908'),

                                                  ('Résines aminiques, résines phénoliques et polyuréthannes, sous formes primaires:', '3909'),

                                                  ('Silicones sous formes primaires', '3910'),

                                                  ('Résines de pétrole, résines de coumarone-indène, polyterpènes, polysulfures, polysulfones et autres produits mentionnés dans la note 3 du présent chapitre, non dénommés ni compris ailleurs, sous formes primaires:', '3911'),

                                                  ('Cellulose et ses dérivés chimiques, non dénommés ni compris ailleurs, sous formes primaires:', '3912'),

                                                  ('Polymères naturels (acide alginique, par exemple) et polymères naturels modifiés (protéines durcies, dérivés chimiques du caoutchouc naturel, par exemple), non dénommés ni compris ailleurs, sous formes primaires:', '3913'),

                                                  ('Échangeurs d''ions à base de polymères des nos 3901  à 3913 , sous formes primaires', '3914'),

                                                  ('Déchets, rognures et débris de matières plastiques:', '3915'),

                                                  ('Monofilaments dont la plus grande dimension de la coupe transversale excède 1 mm (monofils), joncs, bâtons et profilés, même ouvrés en surface mais non autrement travaillés, en matières plastiques:', '3916'),

                                                  ('Tubes et tuyaux et leurs accessoires (joints, coudes, raccords, par exemple), en matières plastiques:', '3917'),

                                                  ('Revêtements de sols en matières plastiques, même auto-adhésifs, en rouleaux ou sous formes de carreaux ou de dalles; revêtements de murs ou de plafonds en matières plastiques définis dans la note 9 du présent chapitre:', '3918'),

                                                  ('Plaques, feuilles, bandes, rubans, pellicules et autres formes plates, auto-adhésifs, en matières plastiques, même en rouleaux:', '3919'),

                                                  ('Autres plaques, feuilles, pellicules, bandes et lames, en matières plastiques non alvéolaires, non renforcées, ni stratifiées, ni munies d''un support, ni pareillement associées à d''autres matières:', '3920'),

                                                  ('Autres plaques, feuilles, pellicules, bandes et lames, en matières plastiques:', '3921'),

                                                  ('Baignoires, douches, éviers, lavabos, bidets, cuvettes d''aisance et leurs sièges et couvercles, réservoirs de chasse et articles similaires pour usages sanitaires ou hygiéniques, en matières plastiques:', '3922'),

                                                  ('Articles de transport ou d''emballage, en matières plastiques; bouchons, couvercles, capsules et autres dispositifs de fermeture, en matières plastiques:', '3923'),

                                                  ('Vaisselle, autres articles de ménage ou d''économie domestique et articles d''hygiène ou de toilette, en matières plastiques:', '3924'),

                                                  ('Articles d''équipement pour la construction, en matières plastiques, non dénommés ni compris ailleurs:', '3925'),

                                                  ('Autres ouvrages en matières plastiques et ouvrages en autres matières des nos 3901  à 3914 :', '3926'),

                                                  ('Caoutchouc naturel, balata, gutta-percha, guayule, chicle et gommes naturelles analogues, sous formes primaires ou en plaques, feuilles ou bandes:', '4001'),

                                                  ('Caoutchouc synthétique et factice pour caoutchouc dérivé des huiles, sous formes primaires ou en plaques, feuilles ou bandes; mélanges des produits du no 4001  avec des produits de la présente position, sous formes primaires ou en plaques, feuilles ou bandes:', '4002'),

                                                  ('Caoutchouc régénéré sous formes primaires ou en plaques, feuilles ou bandes', '4003'),

                                                  ('Déchets, débris et rognures de caoutchouc non durci, même réduits en poudre ou en granulés', '4004'),

                                                  ('Caoutchouc mélangé, non vulcanisé, sous formes primaires ou en plaques, feuilles ou bandes:', '4005'),

                                                  ('Autres formes (baguettes, tubes, profilés, par exemple) et articles (disques, rondelles, par exemple) en caoutchouc non vulcanisé:', '4006'),

                                                  ('Fils et cordes de caoutchouc vulcanisé', '4007'),

                                                  ('Plaques, feuilles, bandes, baguettes et profilés, en caoutchouc vulcanisé non durci:', '4008'),

                                                  ('Tubes et tuyaux en caoutchouc vulcanisé non durci, même pourvus de leurs accessoires (joints, coudes, raccords, par exemple):', '4009'),

                                                  ('Courroies transporteuses ou de transmission, en caoutchouc vulcanisé:', '4010'),

                                                  ('Pneumatiques neufs, en caoutchouc:', '4011'),

                                                  ('Pneumatiques rechapés ou usagés en caoutchouc; bandages, bandes de roulement pour pneumatiques et «flaps», en caoutchouc:', '4012'),

                                                  ('Chambres à air, en caoutchouc:', '4013'),

                                                  ('Articles d''hygiène ou de pharmacie (y compris les tétines), en caoutchouc vulcanisé non durci, même avec parties en caoutchouc durci:', '4014'),

                                                  ('Vêtements et accessoires du vêtement (y compris les gants, mitaines et moufles) en caoutchouc vulcanisé non durci, pour tous usages:', '4015'),

                                                  ('Autres ouvrages en caoutchouc vulcanisé non durci:', '4016'),

                                                  ('Caoutchouc durci (ébonite, par exemple) sous toutes formes, y compris les déchets et débris; ouvrages en caoutchouc durci', '4017'),

                                                  ('Cuirs et peaux bruts de bovins (y compris les buffles) ou d''équidés (frais, ou salés, séchés, chaulés, picklés ou autrement conservés, mais non tannés ni parcheminés ni autrement préparés), même épilés ou refendus:', '4101'),

                                                  ('Peaux brutes d''ovins (fraîches, ou salées, séchées, chaulées, picklées ou autrement conservées, mais non tannées ni parcheminées ni autrement préparées), même épilées ou refendues, autres que celles exclues par la note 1, point c), du présent chapitre:', '4102'),

                                                  ('Autres cuirs et peaux bruts (frais, ou salés, séchés, chaulés, picklés ou autrement conservés, mais non tannés ni parcheminés ni autrement préparés), même épilés ou refendus, autres que ceux exclus par les notes 1, point b), ou 1, point c), du présent chapitre:', '4103'),

                                                  ('Cuirs et peaux tannés ou en croûte de bovins (y compris les buffles) ou d''équidés, épilés, même refendus, mais non autrement préparés:', '4104'),

                                                  ('Peaux tannées ou en croûte d''ovins, épilées, même refendues, mais non autrement préparées:', '4105'),

                                                  ('Cuirs et peaux épilés d''autres animaux et peaux d''animaux dépourvus de poils, tannés ou en croûte, même refendus, mais non autrement préparés:', '4106'),

                                                  ('Cuirs préparés après tannage ou après dessèchement et cuirs et peaux parcheminés, de bovins (y compris les buffles) ou d''équidés, épilés, même refendus, autres que ceux du no 4114 :', '4107'),

                                                  ('Cuirs préparés après tannage ou après dessèchement et cuirs et peaux parcheminés, d''ovins, épilés, même refendus, autres que ceux du no 4114', '4112'),

                                                  ('Cuirs préparés après tannage ou après dessèchement et cuirs et peaux parcheminés, d''autres animaux, épilés, et cuirs préparés après tannage et cuirs et peaux parcheminés, d''animaux dépourvus de poils, même refendus, autres que ceux du no 4114 :', '4113'),

                                                  ('Cuirs et peaux chamoisés (y compris le chamois combiné); cuirs et peaux vernis ou plaqués; cuirs et peaux métallisés:', '4114'),

                                                  ('Cuir reconstitué, à base de cuir ou de fibres de cuir, en plaques, feuilles ou bandes même enroulées; rognures et autres déchets de cuirs ou de peaux préparés ou de cuir reconstitué, non utilisables pour la fabrication d''ouvrages en cuir; sciure, poudre et farine de cuir:', '4115'),

                                                  ('Articles de sellerie ou de bourrellerie pour tous animaux (y compris les traits, laisses, genouillères, muselières, tapis de selles, fontes, manteaux pour chiens et articles similaires), en toutes matières', '4201'),

                                                  ('Malles, valises et mallettes, y compris les mallettes de toilette et les mallettes porte-documents, serviettes, cartables, étuis à lunettes, étuis pour jumelles, appareils photographiques, caméras, instruments de musique ou armes et contenants similaires; sacs de voyage, sacs isolants pour produits alimentaires et boissons, trousses de toilette, sacs à dos, sacs à main, sacs à provisions, portefeuilles, porte-monnaie, porte-cartes, étuis à cigarettes, blagues à tabac, trousses à outils, sacs pour articles de sport, boîtes pour flacons ou bijoux, boîtes à poudre, écrins pour orfèvrerie et contenants similaires, en cuir naturel ou reconstitué, en feuilles de matières plastiques, en matières textiles, en fibre vulcanisée ou en carton, ou recouverts, en totalité ou en majeure partie, de ces mêmes matières ou de papier:', '4202'),

                                                  ('Vêtements et accessoires du vêtement en cuir naturel ou reconstitué:', '4203'),

                                                  ('Autres ouvrages en cuir naturel ou reconstitué:', '4205'),

                                                  ('Ouvrages en boyaux, en baudruches, en vessies ou en tendons', '4206'),

                                                  ('Pelleteries brutes (y compris les têtes, queues, pattes et autres morceaux utilisables en pelleteries), autres que les peaux brutes des nos 4101 , 4102  ou 4103 :', '4301'),

                                                  ('Pelleteries tannées ou apprêtées (y compris les têtes, queues, pattes et autres morceaux, déchets et chutes), non assemblées ou assemblées (sans adjonction d''autres matières), autres que celles du no 4303 :', '4302'),

                                                  ('Vêtements, accessoires du vêtement et autres articles en pelleteries:', '4303'),

                                                  ('Pelleteries factices et articles en pelleteries factices', '4304'),

                                                  ('Bois de chauffage en rondins, bûches, ramilles, fagots ou sous formes similaires; bois en plaquettes ou en particules; sciures, déchets et débris de bois, même agglomérés sous forme de bûches, briquettes, granulés ou sous formes similaires:', '4401'),

                                                  ('Charbon de bois (y compris le charbon de coques ou de noix), même aggloméré:', '4402'),

                                                  ('Bois bruts, même écorcés, désaubiérés ou équarris:', '4403'),

                                                  ('Bois feuillards; échalas fendus; pieux et piquets en bois, appointés, non sciés longitudinalement; bois simplement dégrossis ou arrondis, mais non tournés ni courbés ni autrement travaillés, pour cannes, parapluies, manches d''outils ou similaires; bois en éclisses, lames, rubans et similaires:', '4404'),

                                                  ('Laine (paille) de bois; farine de bois', '4405'),

                                                  ('Traverses en bois pour voies ferrées ou similaires:', '4406'),

                                                  ('Bois sciés ou dédossés longitudinalement, tranchés ou déroulés, même rabotés, poncés ou collés par assemblage en bout, d''une épaisseur excédant 6 mm:', '4407'),

                                                  ('Feuilles pour placage (y compris celles obtenues par tranchage de bois stratifié), feuilles pour contre-plaqués ou pour bois stratifiés similaires et autres bois, sciés longitudinalement, tranchés ou déroulés, même rabotés, poncés, assemblés bord à bord ou en bout, d''une épaisseur n''excédant pas 6 mm:', '4408'),

                                                  ('Bois (y compris les lames et frises à parquet, non assemblées) profilés (languetés, rainés, bouvetés, feuillurés, chanfreinés, joints en V, moulurés, arrondis ou similaires) tout au long d''une ou de plusieurs rives, faces ou bouts, même rabotés, poncés ou collés par assemblage en bout:', '4409'),

                                                  ('Panneaux de particules, panneaux dits «oriented strand board» (OSB) et panneaux similaires (par exemple «waferboards»), en bois ou en autres matières ligneuses, même agglomérés avec des résines ou d''autres liants organiques:', '4410'),

                                                  ('Panneaux de fibres de bois ou d''autres matières ligneuses, même agglomérées avec des résines ou d''autres liants organiques:', '4411'),

                                                  ('Bois contre-plaqués, bois plaqués et bois stratifiés similaires:', '4412'),

                                                  ('Bois dits «densifiés», en blocs, planches, lames ou profilés', '4413'),

                                                  ('Cadres en bois pour tableaux, photographies, miroirs ou objets similaires:', '4414'),

                                                  ('Caisses, caissettes, cageots, cylindres et emballages similaires, en bois; tambours (tourets) pour câbles, en bois; palettes simples, palettes-caisses et autres plateaux de chargement, en bois; rehausses de palettes en bois:', '4415'),

                                                  ('Futailles, cuves, baquets et autres ouvrages de tonnellerie et leurs parties, en bois, y compris les merrains', '4416'),

                                                  ('Outils, montures et manches d''outils, montures de brosses, manches de balais ou de brosses, en bois; formes, embauchoirs et tendeurs pour chaussures, en bois', '4417'),

                                                  ('Ouvrages de menuiserie et pièces de charpente pour construction, y compris les panneaux cellulaires, les panneaux assemblés pour revêtement de sol et les bardeaux (shingles et shakes), en bois:', '4418'),

                                                  ('Articles en bois pour la table ou la cuisine:', '4419'),

                                                  ('Bois marquetés et bois incrustés; coffrets, écrins et étuis pour bijouterie ou orfèvrerie et ouvrages similaires, en bois; statuettes et autres objets d''ornement, en bois; articles d''ameublement en bois ne relevant pas du chapitre 94:', '4420'),

                                                  ('Autres ouvrages en bois:', '4421'),

                                                  ('Liège naturel brut ou simplement préparé; déchets de liège; liège concassé, granulé ou pulvérisé:', '4501'),

                                                  ('Liège naturel, écroûté ou simplement équarri, ou en cubes, plaques, feuilles ou bandes de forme carrée ou rectangulaire (y compris les ébauches à arêtes vives pour bouchons)', '4502'),

                                                  ('Ouvrages en liège naturel:', '4503'),

                                                  ('Liège aggloméré (avec ou sans liant) et ouvrages en liège aggloméré:', '4504'),

                                                  ('Tresses et articles similaires en matières à tresser, même assemblés en bandes; matières à tresser, tresses et articles similaires en matières à tresser, tissés ou parallélisés, à plat, même finis (nattes, paillassons et claies, par exemple):', '4601'),

                                                  ('Ouvrages de vannerie obtenus directement en forme à partir de matières à tresser ou confectionnés à l''aide des articles du no 4601 ; ouvrages en luffa:', '4602'),

                                                  ('Pâtes mécaniques de bois:', '4701'),

                                                  ('Pâtes chimiques de bois, à dissoudre', '4702'),

                                                  ('Pâtes chimiques de bois, à la soude ou au sulfate, autres que les pâtes à dissoudre:', '4703'),

                                                  ('Pâtes chimiques de bois, au bisulfite, autres que les pâtes à dissoudre:', '4704'),

                                                  ('Pâtes de bois obtenues par la combinaison d''un traitement mécanique et d''un traitement chimique', '4705'),

                                                  ('Pâtes de fibres obtenues à partir de papier ou de carton recyclés (déchets et rebuts) ou d''autres matières fibreuses cellulosiques:', '4706'),

                                                  ('Papiers ou cartons à recycler (déchets et rebuts):', '4707'),

                                                  ('Papier journal, en rouleaux ou en feuilles', '4801'),

                                                  ('Papiers et cartons, non couchés ni enduits, des types utilisés pour l''écriture, l''impression ou d''autres fins graphiques et papiers et cartons pour cartes ou bandes à perforer, non perforés, en rouleaux ou en feuilles de forme carrée ou rectangulaire, de tout format, autres que les papiers des nos 4801  ou 4803 ; papiers et cartons formés feuille à feuille (papiers et cartons à la main):', '4802'),

                                                  ('Papiers des types utilisés pour papiers de toilette, pour serviettes à démaquiller, pour essuie-mains, pour serviettes ou pour papiers similaires à usages domestiques, d''hygiène ou de toilette, ouate de cellulose et nappes de fibres de cellulose, même crêpés, plissés, gaufrés, estampés, perforés, coloriés en surface, décorés en surface ou imprimés, en rouleaux ou en feuilles:', '4803'),

                                                  ('Papiers et cartons kraft, non couchés ni enduits, en rouleaux ou en feuilles, autres que ceux des nos 4802  ou 4803 :', '4804'),

                                                  ('Autres papiers et cartons, non couchés ni enduits, en rouleaux ou en feuilles, n''ayant pas subi d''ouvraison complémentaire ou de traitements autres que ceux stipulés dans la note 3 du présent chapitre:', '4805'),

                                                  ('Papiers et cartons sulfurisés, papiers ingraissables, papiers-calques et papier dit «cristal» et autres papiers calandrés transparents ou translucides, en rouleaux ou en feuilles:', '4806'),

                                                  ('Papiers et cartons assemblés à plat par collage, non couchés ni enduits à la surface ni imprégnés, même renforcés intérieurement, en rouleaux ou en feuilles:', '4807'),

                                                  ('Papiers et cartons ondulés (même avec recouvrement par collage), crêpés, plissés, gaufrés, estampés ou perforés, en rouleaux ou en feuilles, autres que les papiers des types décrits dans le libellé du no 4803 :', '4808'),

                                                  ('Papiers carbone, papiers dits «autocopiants» et autres papiers pour duplication ou reports (y compris les papiers couchés, enduits ou imprégnés pour stencils ou pour plaques offset), même imprimés, en rouleaux ou en feuilles:', '4809'),

                                                  ('Papiers et cartons couchés au kaolin ou à d''autres substances inorganiques sur une ou sur les deux faces, avec ou sans liants, à l''exclusion de tout autre couchage ou enduction, même coloriés en surface, décorés en surface ou imprimés, en rouleaux ou en feuilles de forme carrée ou rectangulaire, de tout format:', '4810'),

                                                  ('Papiers, cartons, ouate de cellulose et nappes de fibres de cellulose, couchés, enduits, imprégnés, recouverts, coloriés en surface, décorés en surface ou imprimés, en rouleaux ou en feuilles de forme carrée ou rectangulaire, de tout format, autres que les produits des types décrits dans les libellés des nos 4803 , 4809  ou 4810 :', '4811'),

                                                  ('Blocs filtrants et plaques filtrantes, en pâte à papier', '4812'),

                                                  ('Papier à cigarettes, même découpé à format ou en cahiers ou en tubes:', '4813'),

                                                  ('Papiers peints et revêtements muraux similaires; vitrauphanies:', '4814'),

                                                  ('Papiers carbone, papiers dits «autocopiants» et autres papiers pour duplication ou reports (autres que ceux du no 4809 ), stencils complets et plaques offset, en papier, même conditionnés en boîtes:', '4816'),

                                                  ('Enveloppes, cartes-lettres, cartes postales non illustrées et cartes pour correspondance, en papier ou carton; boîtes, pochettes et présentations similaires, en papier ou carton, renfermant un assortiment d''articles de correspondance:', '4817'),

                                                  ('Papiers des types utilisés pour papiers de toilette et pour papiers similaires, ouate de cellulose ou nappes de fibres de cellulose, des types utilisés à des fins domestiques ou sanitaires, en rouleaux d''une largeur n''excédant pas 36 cm, ou coupés à format; mouchoirs, serviettes à démaquiller, essuie-mains, nappes, serviettes de table, draps de lit et articles similaires à usages domestiques, de toilette, hygiéniques ou hospitaliers, vêtements et accessoires du vêtement, en pâte à papier, papier, ouate de cellulose ou nappes de fibres de cellulose:', '4818'),

                                                  ('Boîtes, sacs, pochettes, cornets et autres emballages en papier, carton, ouate de cellulose ou nappes de fibres de cellulose; cartonnages de bureau, de magasin ou similaires:', '4819'),

                                                  ('Registres, livres comptables, carnets (de notes, de commandes, de quittances), agendas, blocs-mémorandums, blocs de papier à lettres et ouvrages similaires, cahiers, sous-main, classeurs, reliures (à feuillets mobiles ou autres), chemises et couvertures à dossiers et autres articles scolaires, de bureau ou de papeterie, y compris les liasses et carnets manifold, même comportant des feuilles de papier carbone, en papier ou carton; albums pour échantillonnages ou pour collections et couvertures pour livres, en papier ou carton:', '4820'),

                                                  ('Étiquettes de tous genres, en papier ou carton, imprimées ou non:', '4821'),

                                                  ('Tambours, bobines, fusettes, canettes et supports similaires, en pâte à papier, papier ou carton, même perforés ou durcis:', '4822'),

                                                  ('Autres papiers, cartons, ouate de cellulose et nappes de fibres de cellulose découpés à format; autres ouvrages en pâte à papier, papier, carton, ouate de cellulose ou nappes de fibres de cellulose:', '4823'),

                                                  ('Livres, brochures et imprimés similaires, même sur feuillets isolés:', '4901'),

                                                  ('Journaux et publications périodiques imprimés, même illustrés ou contenant de la publicité:', '4902'),

                                                  ('Albums ou livres d''images et albums à dessiner ou à colorier, pour enfants', '4903'),

                                                  ('Musique manuscrite ou imprimée, illustrée ou non, même reliée', '4904'),

                                                  ('Ouvrages cartographiques de tous genres, y compris les cartes murales, les plans topographiques et les globes, imprimés:', '4905'),

                                                  ('Plans et dessins d''architectes, d''ingénieurs et autres plans et dessins industriels, commerciaux, topographiques ou similaires, obtenus en original à la main; textes écrits à la main; reproductions photographiques sur papier sensibilisé et copies obtenues au carbone des plans, dessins ou textes visés ci-dessus', '4906'),

                                                  ('Timbres-poste, timbres fiscaux et analogues, non oblitérés, ayant cours ou destinés à avoir cours dans le pays dans lequel ils ont, ou auront, une valeur faciale reconnue; papier timbré; billets de banque; chèques; titres d''actions ou d''obligations et titres similaires:', '4907'),

                                                  ('Décalcomanies de tous genres:', '4908'),

                                                  ('Cartes postales imprimées ou illustrées; cartes imprimées comportant des vœux ou des messages personnels, même illustrées, avec ou sans enveloppes, garnitures ou applications', '4909'),

                                                  ('Calendriers de tous genres, imprimés, y compris les blocs de calendriers à effeuiller', '4910'),

                                                  ('Autres imprimés, y compris les images, les gravures et les photographies:', '4911'),

                                                  ('Cocons de vers à soie propres au dévidage', '5001'),

                                                  ('Soie grège (non moulinée)', '5002'),

                                                  ('Déchets de soie (y compris les cocons non dévidables, les déchets de fils et les effilochés)', '5003'),

                                                  ('Fils de soie (autres que les fils de déchets de soie) non conditionnés pour la vente au détail:', '5004'),

                                                  ('Fils de déchets de soie, non conditionnés pour la vente au détail:', '5005'),

                                                  ('Fils de soie ou de déchets de soie, conditionnés pour la vente au détail; poil de Messine (crin de Florence):', '5006'),

                                                  ('Tissus de soie ou de déchets de soie:', '5007'),

                                                  ('Laines, non cardées ni peignées:', '5101'),

                                                  ('Poils fins ou grossiers, non cardés ni peignés:', '5102'),

                                                  ('Déchets de laine ou de poils fins ou grossiers, y compris les déchets de fils mais à l''exclusion des effilochés:', '5103'),

                                                  ('Effilochés de laine ou de poils fins ou grossiers', '5104'),

                                                  ('Laine, poils fins ou grossiers, cardés ou peignés (y compris la «laine peignée en vrac»):', '5105'),

                                                  ('Fils de laine cardée, non conditionnés pour la vente au détail:', '5106'),

                                                  ('Fils de laine peignée, non conditionnés pour la vente au détail:', '5107'),

                                                  ('Fils de poils fins, cardés ou peignés, non conditionnés pour la vente au détail:', '5108'),

                                                  ('Fils de laine ou de poils fins, conditionnés pour la vente au détail:', '5109'),

                                                  ('Fils de poils grossiers ou de crin (y compris les fils de crin guipés), même conditionnés pour la vente au détail', '5110'),

                                                  ('Tissus de laine cardée ou de poils fins cardés:', '5111'),

                                                  ('Tissus de laine peignée ou de poils fins peignés:', '5112'),

                                                  ('Tissus de poils grossiers ou de crin', '5113'),

                                                  ('Coton, non cardé ni peigné:', '5201'),

                                                  ('Déchets de coton (y compris les déchets de fils et les effilochés):', '5202'),

                                                  ('Coton, cardé ou peigné', '5203'),

                                                  ('Fils à coudre de coton, même conditionnés pour la vente au détail:', '5204'),

                                                  ('Fils de coton (autres que les fils à coudre), contenant au moins 85 % en poids de coton, non conditionnés pour la vente au détail:', '5205'),

                                                  ('Fils de coton (autres que les fils à coudre), contenant moins de 85 % en poids de coton, non conditionnés pour la vente au détail:', '5206'),

                                                  ('Fils de coton (autres que les fils à coudre) conditionnés pour la vente au détail:', '5207'),

                                                  ('Tissus de coton, contenant au moins 85 % en poids de coton, d''un poids n''excédant pas 200 g/m2:', '5208'),

                                                  ('Tissus de coton, contenant au moins 85 % en poids de coton, d''un poids excédant 200 g/m2:', '5209'),

                                                  ('Tissus de coton, contenant moins de 85 % en poids de coton, mélangés principalement ou uniquement avec des fibres synthétiques ou artificielles, d''un poids n''excédant pas 200 g/m2:', '5210'),

                                                  ('Tissus de coton, contenant moins de 85 % en poids de coton, mélangés principalement ou uniquement avec des fibres synthétiques ou artificielles, d''un poids excédant 200 g/m2:', '5211'),

                                                  ('Autres tissus de coton:', '5212'),

                                                  ('Lin brut ou travaillé mais non filé; étoupes et déchets de lin (y compris les déchets de fils et les effilochés):', '5301'),

                                                  ('Chanvre (Cannabis sativa L.) brut ou travaillé mais non filé; étoupes et déchets de chanvre (y compris les déchets de fils et les effilochés):', '5302'),

                                                  ('Jute et autres fibres textiles libériennes (à l''exclusion du lin, du chanvre et de la ramie), bruts ou travaillés mais non filés; étoupes et déchets de ces fibres (y compris les déchets de fils et les effilochés):', '5303'),

                                                  ('Coco, abaca (chanvre de Manille ou Musa textilis Nee), ramie et autres fibres textiles végétales non dénommées ni comprises ailleurs, bruts ou travaillés mais non filés; étoupes et déchets de ces fibres (y compris les déchets de fils et les effilochés)', '5305'),

                                                  ('Fils de lin:', '5306'),

                                                  ('Fils de jute ou d''autres fibres textiles libériennes du no 5303 :', '5307'),

                                                  ('Fils d''autres fibres textiles végétales; fils de papier:', '5308'),

                                                  ('Tissus de lin:', '5309'),

                                                  ('Tissus de jute ou d''autres fibres textiles libériennes du no 5303 :', '5310'),

                                                  ('Tissus d''autres fibres textiles végétales; tissus de fils de papier:', '5311'),

                                                  ('Fils à coudre de filaments synthétiques ou artificiels, même conditionnés pour la vente au détail:', '5401'),

                                                  ('Fils de filaments synthétiques (autres que les fils à coudre), non conditionnés pour la vente au détail, y compris les monofilaments synthétiques de moins de 67 décitex:', '5402'),

                                                  ('Fils de filaments artificiels (autres que les fils à coudre), non conditionnés pour la vente au détail, y compris les monofilaments artificiels de moins de 67 décitex:', '5403'),

                                                  ('Monofilaments synthétiques de 67 décitex ou plus et dont la plus grande dimension de la coupe transversale n''excède pas 1 mm; lames et formes similaires (paille artificielle, par exemple) en matières textiles synthétiques, dont la largeur apparente n''excède pas 5 mm:', '5404'),

                                                  ('Monofilaments artificiels de 67 décitex ou plus et dont la plus grande dimension de la coupe transversale n''excède pas 1 mm; lames et formes similaires (paille artificielle, par exemple) en matières textiles artificielles, dont la largeur apparente n''excède pas 5 mm', '5405'),

                                                  ('Fils de filaments synthétiques ou artificiels (autres que les fils à coudre), conditionnés pour la vente au détail', '5406'),

                                                  ('Tissus de fils de filaments synthétiques, y compris les tissus obtenus à partir des produits du no 5404 :', '5407'),

                                                  ('Tissus de fils de filaments artificiels, y compris les tissus obtenus à partir des produits du no 5405 :', '5408'),

                                                  ('Câbles de filaments synthétiques:', '5501'),

                                                  ('Câbles de filaments artificiels:', '5502'),

                                                  ('Fibres synthétiques discontinues, non cardées ni peignées ni autrement transformées pour la filature:', '5503'),

                                                  ('Fibres artificielles discontinues, non cardées ni peignées ni autrement transformées pour la filature:', '5504'),

                                                  ('Déchets de fibres synthétiques ou artificielles (y compris les blousses, les déchets de fils et les effilochés):', '5505'),

                                                  ('Fibres synthétiques discontinues, cardées, peignées ou autrement transformées pour la filature:', '5506'),

                                                  ('Fibres artificielles discontinues, cardées, peignées ou autrement transformées pour la filature', '5507'),

                                                  ('Fils à coudre de fibres synthétiques ou artificielles discontinues, même conditionnés pour la vente au détail:', '5508'),

                                                  ('Fils de fibres synthétiques discontinues (autres que les fils à coudre), non conditionnés pour la vente au détail:', '5509'),

                                                  ('Fils de fibres artificielles discontinues (autres que les fils à coudre), non conditionnés pour la vente au détail:', '5510'),

                                                  ('Fils de fibres synthétiques ou artificielles discontinues (autres que les fils à coudre), conditionnés pour la vente au détail:', '5511'),

                                                  ('Tissus de fibres synthétiques discontinues contenant au moins 85 % en poids de fibres synthétiques discontinues:', '5512'),

                                                  ('Tissus de fibres synthétiques discontinues, contenant moins de 85 % en poids de ces fibres, mélangés principalement ou uniquement avec du coton, d''un poids n''excédant pas 170 g/m2:', '5513'),

                                                  ('Tissus de fibres synthétiques discontinues, contenant moins de 85 % en poids de ces fibres, mélangés principalement ou uniquement avec du coton, d''un poids excédant 170 g/m2:', '5514'),

                                                  ('Autres tissus de fibres synthétiques discontinues:', '5515'),

                                                  ('Tissus de fibres artificielles discontinues:', '5516'),

                                                  ('Ouates de matières textiles et articles en ces ouates; fibres textiles d''une longueur n''excédant pas 5 mm (tontisses), nœuds et noppes (boutons) de matières textiles:', '5601'),

                                                  ('Feutres, même imprégnés, enduits, recouverts ou stratifiés:', '5602'),

                                                  ('Nontissés, même imprégnés, enduits, recouverts ou stratifiés:', '5603'),

                                                  ('Fils et cordes de caoutchouc, recouverts de textiles; fils textiles, lames et formes similaires des nos 5404  ou 5405 , imprégnés, enduits, recouverts ou gainés de caoutchouc ou de matière plastique:', '5604'),

                                                  ('Filés métalliques et fils métallisés, même guipés, constitués par des fils textiles, des lames ou formes similaires des nos 5404  ou 5405 , combinés avec du métal sous forme de fils, de lames ou de poudres, ou recouverts de métal', '5605'),

                                                  ('Fils guipés, lames et formes similaires des nos 5404  ou 5405  guipées, autres que ceux du no 5605  et autres que les fils de crin guipés; fils de chenille; fils dits «de chaînette»:', '5606'),

                                                  ('Ficelles, cordes et cordages, tressés ou non, même imprégnés, enduits, recouverts ou gainés de caoutchouc ou de matière plastique:', '5607'),

                                                  ('Filets à mailles nouées, en nappes ou en pièces, obtenus à partir de ficelles, cordes ou cordages; filets confectionnés pour la pêche et autres filets confectionnés, en matières textiles:', '5608'),

                                                  ('Articles en fils, lames ou formes similaires des nos 5404  ou 5405 , ficelles, cordes ou cordages, non dénommés ni compris ailleurs', '5609'),

                                                  ('Tapis en matières textiles, à points noués ou enroulés, même confectionnés:', '5701'),

                                                  ('Tapis et autres revêtements de sol en matières textiles, tissés, non touffetés ni floqués, même confectionnés, y compris les tapis dits «kelim» ou «kilim», «schumacks» ou «soumak», «karamanie» et tapis similaires tissés à la main:', '5702'),

                                                  ('Tapis et autres revêtements de sol en matières textiles (y compris le gazon), touffetés, même confectionnés:', '5703'),

                                                  ('Tapis et autres revêtements de sol, en feutre, non touffetés ni floqués, même confectionnés:', '5704'),

                                                  ('Autres tapis et revêtements de sol en matières textiles, même confectionnés:', '5705'),

                                                  ('Velours et peluches tissés et tissus de chenille, autres que les articles des nos 5802  ou 5806 :', '5801'),

                                                  ('Tissus bouclés du genre éponge, autres que les articles du no 5806 ; surfaces textiles touffetées, autres que les produits du no 5703 :', '5802'),

                                                  ('Tissus à point de gaze, autres que les articles du no 5806 :', '5803'),

                                                  ('Tulles, tulles-bobinots et tissus à mailles nouées; dentelles en pièces, en bandes ou en motifs, autres que les produits des nos 6002  à 6006 :', '5804'),

                                                  ('Tapisseries tissées à la main (genre Gobelins, Flandres, Aubusson, Beauvais et similaires) et tapisseries à l''aiguille (au petit point, au point de croix, par exemple), même confectionnées', '5805'),

                                                  ('Rubanerie autre que les articles du no 5807 ; rubans sans trame, en fils ou fibres parallélisés et encollés (bolducs):', '5806'),

                                                  ('Étiquettes, écussons et articles similaires en matières textiles, en pièces, en rubans ou découpés, non brodés:', '5807'),

                                                  ('Tresses en pièces; articles de passementerie et articles ornementaux analogues, en pièces, sans broderie, autres que ceux en bonneterie; glands, floches, olives, noix, pompons et articles similaires:', '5808'),

                                                  ('Tissus de fils de métal et tissus de filés métalliques ou de fils textiles métallisés du no 5605 , des types utilisés pour l''habillement, l''ameublement ou usages similaires, non dénommés ni compris ailleurs', '5809'),

                                                  ('Broderies en pièces, en bandes ou en motifs:', '5810'),

                                                  ('Produits textiles matelassés en pièces, constitués d''une ou plusieurs couches de matières textiles associées à une matière de rembourrage par piqûre, capitonnage ou autre cloisonnement, autres que les broderies du no 5810', '5811'),

                                                  ('Tissus enduits de colle ou de matières amylacées, des types utilisés pour la reliure, le cartonnage, la gainerie ou usages similaires; toiles à calquer ou transparentes pour le dessin; toiles préparées pour la peinture; bougran et tissus similaires raidis des types utilisés pour la chapellerie:', '5901'),

                                                  ('Nappes tramées pour pneumatiques obtenues à partir de fils à haute ténacité de nylon ou d''autres polyamides, de polyesters ou de rayonne viscose:', '5902'),

                                                  ('Tissus imprégnés, enduits ou recouverts de matière plastique ou stratifiés avec de la matière plastique, autres que ceux du no 5902 :', '5903'),

                                                  ('Linoléums, même découpés; revêtements de sol consistant en un enduit ou un recouvrement appliqué sur un support textile, même découpés:', '5904'),

                                                  ('Revêtements muraux en matières textiles:', '5905'),

                                                  ('Tissus caoutchoutés, autres que ceux du no 5902 :', '5906'),

                                                  ('Autres tissus imprégnés, enduits ou recouverts; toiles peintes pour décors de théâtres, fonds d''atelier ou usages analogues', '5907'),

                                                  ('Mèches tissées, tressées ou tricotées, en matières textiles, pour lampes, réchauds, briquets, bougies ou similaires; manchons à incandescence et étoffes tubulaires tricotées servant à leur fabrication, même imprégnés', '5908'),

                                                  ('Tuyaux pour pompes et tuyaux similaires, en matières textiles, même avec armatures ou accessoires en autres matières:', '5909'),

                                                  ('Courroies transporteuses ou de transmission en matières textiles, même imprégnées, enduites, recouvertes de matière plastique ou stratifiées avec de la matière plastique ou renforcées de métal ou d''autres matières', '5910'),

                                                  ('Produits et articles textiles pour usages techniques, visés à la note 8 du présent chapitre:', '5911'),

                                                  ('Velours, peluches (y compris les étoffes dites «à longs poils») et étoffes bouclées, en bonneterie:', '6001'),

                                                  ('Étoffes de bonneterie d''une largeur n''excédant pas 30 cm, contenant en poids 5 % ou plus de fils d''élastomères ou de fils de caoutchouc, autres que celles du no 6001 :', '6002'),

                                                  ('Étoffes de bonneterie d''une largeur n''excédant pas 30 cm, autres que celles des nos 6001  et 6002 :', '6003'),

                                                  ('Étoffes de bonneterie d''une largeur excédant 30 cm, contenant en poids 5 % ou plus de fils d''élastomères ou de fils de caoutchouc, autres que celles du no 6001 :', '6004'),

                                                  ('Étoffes de bonneterie-chaîne (y compris celles obtenues sur métiers à galonner), autres que celles des nos 6001  à 6004 :', '6005'),

                                                  ('Autres étoffes de bonneterie:', '6006'),

                                                  ('Manteaux, cabans, capes, anoraks, blousons et articles similaires, en bonneterie, pour hommes ou garçonnets, à l''exclusion des articles du no 6103 :', '6101'),

                                                  ('Manteaux, cabans, capes, anoraks, blousons et articles similaires, en bonneterie, pour femmes ou fillettes, à l''exclusion des articles du no 6104 :', '6102'),

                                                  ('Costumes ou complets, ensembles, vestons, pantalons, salopettes à bretelles, culottes et shorts (autres que pour le bain), en bonneterie, pour hommes ou garçonnets:', '6103'),

                                                  ('Costumes tailleurs, ensembles, vestes, robes, jupes, jupes-culottes, pantalons, salopettes à bretelles, culottes et shorts (autres que pour le bain), en bonneterie, pour femmes ou fillettes:', '6104'),

                                                  ('Chemises et chemisettes, en bonneterie, pour hommes ou garçonnets:', '6105'),

                                                  ('Chemisiers, blouses, blouses-chemisiers et chemisettes, en bonneterie, pour femmes ou fillettes:', '6106'),

                                                  ('Slips, caleçons, chemises de nuit, pyjamas, peignoirs de bain, robes de chambre et articles similaires, en bonneterie, pour hommes ou garçonnets:', '6107'),

                                                  ('Combinaisons ou fonds de robes, jupons, slips, chemises de nuit, pyjamas, déshabillés, peignoirs de bain, robes de chambre et articles similaires, en bonneterie, pour femmes ou fillettes:', '6108'),

                                                  ('T-shirts et maillots de corps, en bonneterie:', '6109'),

                                                  ('Chandails, pull-overs, cardigans, gilets et articles similaires, y compris les sous-pulls, en bonneterie:', '6110'),

                                                  ('Vêtements et accessoires du vêtement, en bonneterie, pour bébés:', '6111'),

                                                  ('Survêtements de sport (trainings), combinaisons et ensembles de ski, maillots, culottes et slips de bain, en bonneterie:', '6112'),

                                                  ('Vêtements confectionnés en étoffes de bonneterie des nos 5903 , 5906  ou 5907 :', '6113'),

                                                  ('Autres vêtements, en bonneterie:', '6114'),

                                                  ('Collants (bas-culottes), bas, mi-bas, chaussettes et autres articles chaussants, y compris les collants (bas-culottes), bas et mi-bas à compression dégressive (les bas à varices, par exemple), en bonneterie:', '6115'),

                                                  ('Gants, mitaines et moufles, en bonneterie:', '6116'),

                                                  ('Autres accessoires confectionnés du vêtement, en bonneterie; parties de vêtements ou d''accessoires du vêtement, en bonneterie:', '6117'),

                                                  ('Manteaux, cabans, capes, anoraks, blousons et articles similaires, pour hommes ou garçonnets, à l''exclusion des articles du no 6203 :', '6201'),

                                                  ('Manteaux, cabans, capes, anoraks, blousons et articles similaires, pour femmes ou fillettes, à l''exclusion des articles du no 6204 :', '6202'),

                                                  ('Costumes ou complets, ensembles, vestons, pantalons, salopettes à bretelles, culottes et shorts (autres que pour le bain), pour hommes ou garçonnets:', '6203'),

                                                  ('Costumes tailleurs, ensembles, vestes, robes, jupes, jupes-culottes, pantalons, salopettes à bretelles, culottes et shorts (autres que pour le bain), pour femmes ou fillettes:', '6204'),

                                                  ('Chemises et chemisettes, pour hommes ou garçonnets:', '6205'),

                                                  ('Chemisiers, blouses, blouses-chemisiers et chemisettes, pour femmes ou fillettes:', '6206'),

                                                  ('Gilets de corps, slips, caleçons, chemises de nuit, pyjamas, peignoirs de bain, robes de chambre et articles similaires, pour hommes ou garçonnets:', '6207'),

                                                  ('Gilets de corps et chemises de jour, combinaisons ou fonds de robes, jupons, slips, chemises de nuit, pyjamas, déshabillés, peignoirs de bain, robes de chambre et articles similaires, pour femmes ou fillettes:', '6208'),

                                                  ('Vêtements et accessoires du vêtement pour bébés:', '6209'),

                                                  ('Vêtements confectionnés en produits des nos 5602 , 5603 , 5903 , 5906  ou 5907 :', '6210'),

                                                  ('Survêtements de sport (trainings), combinaisons et ensembles de ski, maillots, culottes et slips de bain; autres vêtements:', '6211'),

                                                  ('Soutiens-gorge, gaines, corsets, bretelles, jarretelles, jarretières et articles similaires et leurs parties, même en bonneterie:', '6212'),

                                                  ('Mouchoirs et pochettes:', '6213'),

                                                  ('Châles, écharpes, foulards, cache-nez, cache-col, mantilles, voiles et voilettes, et articles similaires:', '6214'),

                                                  ('Cravates, nœuds papillons et foulards cravates:', '6215'),

                                                  ('Gants, mitaines et moufles', '6216'),

                                                  ('Autres accessoires confectionnés du vêtement; parties de vêtements ou d''accessoires du vêtement, autres que celles du no 6212 :', '6217'),

                                                  ('Couvertures:', '6301'),

                                                  ('Linge de lit, de table, de toilette ou de cuisine:', '6302'),

                                                  ('Vitrages, rideaux et stores d''intérieur; cantonnières et tours de lit:', '6303'),

                                                  ('Autres articles d''ameublement, à l''exclusion de ceux du no 9404 :', '6304'),

                                                  ('Sacs et sachets d''emballage:', '6305'),

                                                  ('Bâches et stores d’extérieur; tentes (y compris les tonnelles temporaires et articles similaires); voiles pour embarcations, planches à voile ou chars à voile; articles de campement:', '6306'),

                                                  ('Autres articles confectionnés, y compris les patrons de vêtements:', '6307'),

                                                  ('Assortiments composés de pièces de tissus et de fils, même avec accessoires, pour la confection de tapis, de tapisseries, de nappes de table ou de serviettes brodées, ou d''articles textiles similaires, en emballages pour la vente au détail', '6308'),

                                                  ('Articles de friperie', '6309'),

                                                  ('Chiffons, ficelles, cordes et cordages, en matières textiles, sous forme de déchets ou d''articles hors d''usage:', '6310'),

                                                  ('Chaussures étanches à semelles extérieures et dessus en caoutchouc ou en matière plastique, dont le dessus n''a été ni réuni à la semelle extérieure par couture ou par des rivets, des clous, des vis, des tétons ou des dispositifs similaires, ni formé de différentes parties assemblées par ces mêmes procédés:', '6401'),

                                                  ('Autres chaussures à semelles extérieures et dessus en caoutchouc ou en matière plastique:', '6402'),

                                                  ('Chaussures à semelles extérieures en caoutchouc, matière plastique, cuir naturel ou reconstitué et dessus en cuir naturel:', '6403'),

                                                  ('Chaussures à semelles extérieures en caoutchouc, matière plastique, cuir naturel ou reconstitué et dessus en matières textiles:', '6404'),

                                                  ('Autres chaussures:', '6405'),

                                                  ('Parties de chaussures (y compris les dessus même fixés à des semelles autres que les semelles extérieures); semelles intérieures amovibles, talonnettes et articles similaires amovibles; guêtres, jambières et articles similaires, et leurs parties:', '6406'),

                                                  ('Cloches non dressées (mises en forme) ni tournurées (mises en tournure), plateaux (disques), manchons (cylindres) même fendus dans le sens de la hauteur, en feutre, pour chapeaux', '6501'),

                                                  ('Cloches ou formes pour chapeaux, tressées ou fabriquées par l''assemblage de bandes en toutes matières, non dressées (mises en forme) ni tournurées (mises en tournure) ni garnies', '6502'),

                                                  ('Chapeaux et autres coiffures, tressés ou fabriqués par l''assemblage de bandes en toutes matières, même garnis', '6504'),

                                                  ('Chapeaux et autres coiffures en bonneterie ou confectionnés à l''aide de dentelles, de feutre ou d''autres produits textiles, en pièces (mais non en bandes), même garnis; résilles et filets à cheveux en toutes matières, même garnis:', '6505'),

                                                  ('Autres chapeaux et coiffures, même garnis:', '6506'),

                                                  ('Bandes pour garniture intérieure, coiffes, couvre-coiffures, carcasses, visières et jugulaires pour la chapellerie', '6507'),

                                                  ('Parapluies, ombrelles et parasols (y compris les parapluies-cannes, les parasols de jardin et articles similaires):', '6601'),

                                                  ('Cannes, cannes-sièges, fouets, cravaches et articles similaires', '6602'),

                                                  ('Parties, garnitures et accessoires pour articles des nos 6601  ou 6602 :', '6603'),

                                                  ('Peaux et autres parties d''oiseaux revêtues de leurs plumes ou de leur duvet, plumes, parties de plumes, duvet et articles en ces matières, autres que les produits du no 0505  et les tuyaux et tiges de plumes, travaillés', '6701'),

                                                  ('Fleurs, feuillages et fruits artificiels et leurs parties; articles confectionnés en fleurs, feuillages ou fruits artificiels:', '6702'),

                                                  ('Cheveux remis, amincis, blanchis ou autrement préparés; laine, poils et autres matières textiles, préparés pour la fabrication de perruques ou d''articles similaires', '6703'),

                                                  ('Perruques, barbes, sourcils, cils, mèches et articles analogues en cheveux, poils ou matières textiles; ouvrages en cheveux non dénommés ni compris ailleurs:', '6704'),

                                                  ('Pavés, bordures de trottoirs et dalles de pavage, en pierres naturelles (autres que l''ardoise)', '6801'),

                                                  ('Pierres de taille ou de construction (autres que l''ardoise) travaillées et ouvrages en ces pierres, à l''exclusion de ceux du no 6801 ; cubes, dés et articles similaires pour mosaïques, en pierres naturelles (y compris l''ardoise), même sur support; granulés, éclats et poudres de pierres naturelles (y compris l''ardoise), colorés artificiellement:', '6802'),

                                                  ('Ardoise naturelle travaillée et ouvrages en ardoise naturelle ou agglomérée (ardoisine):', '6803'),

                                                  ('Meules et articles similaires, sans bâtis, à moudre, à défibrer, à broyer, à aiguiser, à polir, à rectifier, à trancher ou à tronçonner, pierres à aiguiser ou à polir à la main, et leurs parties, en pierres naturelles, en abrasifs naturels ou artificiels agglomérés ou en céramique, même avec parties en autres matières:', '6804'),

                                                  ('Abrasifs naturels ou artificiels en poudre ou en grains, appliqués sur produits textiles, papier, carton ou autres matières, même découpés, cousus ou autrement assemblés:', '6805'),

                                                  ('Laines de laitier, de scories, de roche et laines minérales similaires; vermiculite expansée, argiles expansées, mousse de scories et produits minéraux similaires expansés; mélanges et ouvrages en matières minérales à usages d''isolants thermiques ou sonores ou pour l''absorption du son, à l''exclusion de ceux des nos 6811 , 6812  ou du chapitre 69:', '6806'),

                                                  ('Ouvrages en asphalte ou en produits similaires (poix de pétrole, brais, par exemple):', '6807'),

                                                  ('Panneaux, planches, carreaux, blocs et articles similaires, en fibres végétales, en paille ou en copeaux, plaquettes, particules, sciures ou autres déchets de bois, agglomérés avec du ciment, du plâtre ou d''autres liants minéraux', '6808'),

                                                  ('Ouvrages en plâtre ou en compositions à base de plâtre:', '6809'),

                                                  ('Ouvrages en ciment, en béton ou en pierre artificielle, même armés:', '6810'),

                                                  ('Ouvrages en amiante-ciment, cellulose-ciment ou similaires:', '6811'),

                                                  ('Amiante (asbeste) travaillé, en fibres; mélanges à base d''amiante ou à base d''amiante et de carbonate de magnésium; ouvrages en ces mélanges ou en amiante (fils, tissus, vêtements, coiffures, chaussures, joints, par exemple), même armés, autres que ceux des nos 6811  ou 6813 :', '6812'),

                                                  ('Garnitures de friction (plaques, rouleaux, bandes, segments, disques, rondelles, plaquettes, par exemple), non montées, pour freins, pour embrayages ou pour tous organes de frottement, à base d''amiante (asbeste), d''autres substances minérales ou de cellulose, même combinés avec des textiles ou d''autres matières:', '6813'),

                                                  ('Mica travaillé et ouvrages en mica, y compris le mica aggloméré ou reconstitué, même sur support en papier, en carton ou en autres matières:', '6814'),

                                                  ('Ouvrages en pierre ou en autres matières minérales (y compris les fibres de carbone, les ouvrages en ces matières et en tourbe), non dénommés ni compris ailleurs:', '6815'),

                                                  ('Briques, dalles, carreaux et autres pièces céramiques en farines siliceuses fossiles (kieselguhr, tripolite, diatomite, par exemple) ou en terres siliceuses analogues', '6901'),

                                                  ('Briques, dalles, carreaux et pièces céramiques analogues de construction, réfractaires, autres que ceux en farines siliceuses fossiles ou en terres siliceuses analogues:', '6902'),

                                                  ('Autres articles céramiques réfractaires (cornues, creusets, moufles, busettes, tampons, supports, coupelles, tubes, tuyaux, gaines, baguettes, plaques pour tiroir, par exemple), autres que ceux en farines siliceuses fossiles ou en terres siliceuses analogues:', '6903'),

                                                  ('Briques de construction, hourdis, cache-poutrelles et articles similaires, en céramique:', '6904'),

                                                  ('Tuiles, éléments de cheminée, conduits de fumée, ornements architectoniques, en céramique, et autres poteries de bâtiment:', '6905'),

                                                  ('Tuyaux, gouttières et accessoires de tuyauterie, en céramique', '6906'),

                                                  ('Carreaux et dalles de pavement ou de revêtement, en céramique; cubes, dés et articles similaires pour mosaïques, en céramique, même sur un support; pièces de finition, en céramique:', '6907'),

                                                  ('Appareils et articles pour usages chimiques ou autres usages techniques, en céramique; auges, bacs et récipients similaires pour l''économie rurale, en céramique; cruchons et récipients similaires de transport ou d''emballage, en céramique:', '6909'),

                                                  ('Éviers, lavabos, colonnes de lavabos, baignoires, bidets, cuvettes d''aisance, réservoirs de chasse, urinoirs et appareils fixes similaires pour usages sanitaires, en céramique:', '6910'),

                                                  ('Vaisselle, autres articles de ménage ou d''économie domestique et articles d''hygiène ou de toilette, en porcelaine:', '6911'),

                                                  ('Vaisselle, autres articles de ménage ou d''économie domestique et articles d''hygiène ou de toilette, en céramique, autres qu''en porcelaine:', '6912'),

                                                  ('Statuettes et autres objets d''ornementation en céramique:', '6913'),

                                                  ('Autres ouvrages en céramique:', '6914'),

                                                  ('Calcin et autres déchets et débris de verre, à l’exclusion du verre de tubes cathodiques et autres verre activés du no 8549 ; verre en masse:', '7001'),

                                                  ('Verre en billes (autres que les microsphères du no 7018 ), barres, baguettes ou tubes, non travaillé:', '7002'),

                                                  ('Verre dit «coulé», en plaques, feuilles ou profilés, même à couche absorbante, réfléchissante ou non réfléchissante, mais non autrement travaillé:', '7003'),

                                                  ('Verre étiré ou soufflé, en feuilles, même à couche absorbante, réfléchissante ou non réfléchissante, mais non autrement travaillé:', '7004'),

                                                  ('Glace (verre flotté et verre douci ou poli sur une ou deux faces) en plaques ou en feuilles, même à couche absorbante, réfléchissante ou non réfléchissante, mais non autrement travaillée:', '7005'),

                                                  ('Verre des nos 7003 , 7004  ou 7005 , courbé, biseauté, gravé, percé, émaillé ou autrement travaillé, mais non encadré ni associé à d''autres matières:', '7006'),

                                                  ('Verre de sécurité, consistant en verres trempés ou formés de feuilles contrecollées:', '7007'),

                                                  ('Vitrages isolants à parois multiples:', '7008'),

                                                  ('Miroirs en verre, même encadrés, y compris les miroirs rétroviseurs:', '7009'),

                                                  ('Bonbonnes, bouteilles, flacons, bocaux, pots, emballages tubulaires, ampoules et autres récipients de transport ou d''emballage, en verre; bocaux à conserves en verre; bouchons, couvercles et autres dispositifs de fermeture, en verre:', '7010'),

                                                  ('Ampoules et enveloppes tubulaires, ouvertes, et leurs parties, en verre, sans garnitures, pour lampes et sources lumineuses électriques, tubes cathodiques ou similaires:', '7011'),

                                                  ('Objets en verre pour le service de la table, pour la cuisine, la toilette, le bureau, l''ornementation des appartements ou usages similaires, autres que ceux des nos 7010  ou 7018 :', '7013'),

                                                  ('Verrerie de signalisation et éléments d''optique en verre (autres que ceux du no 7015 ), non travaillés optiquement', '7014'),

                                                  ('Verres d''horlogerie et verres analogues, verres de lunetterie commune ou médicale, bombés, cintrés, creusés ou similaires, non travaillés optiquement; sphères (boules) creuses et leurs segments, en verre, pour la fabrication de ces verres:', '7015'),

                                                  ('Pavés, dalles, briques, carreaux, tuiles et autres articles, en verre pressé ou moulé, même armé, pour le bâtiment ou la construction; cubes, dés et autre verrerie, même sur support, pour mosaïques ou décorations similaires; verres assemblés en vitraux; verre dit «multicellulaire» ou verre «mousse» en blocs, panneaux, plaques, coquilles ou formes similaires:', '7016'),

                                                  ('Verrerie de laboratoire, d''hygiène ou de pharmacie, même graduée ou jaugée:', '7017'),

                                                  ('Perles de verre, imitations de perles fines ou de culture, imitations de pierres gemmes et articles similaires de verroterie, et leurs ouvrages autres que la bijouterie de fantaisie; yeux en verre autres que de prothèse; statuettes et autres objets d''ornementation, en verre travaillé au chalumeau (verre filé), autres que la bijouterie de fantaisie; microsphères de verre d''un diamètre n''excédant pas 1 mm:', '7018'),

                                                  ('Fibres de verre (y compris la laine de verre) et ouvrages en ces matières (fils, stratifils (rovings), tissus, par exemple):', '7019'),

                                                  ('Autres ouvrages en verre:', '7020'),

                                                  ('Perles fines ou de culture, même travaillées ou assorties mais non enfilées, ni montées ni serties; perles fines ou de culture, enfilées temporairement pour la facilité du transport:', '7101'),

                                                  ('Diamants, même travaillés, mais non montés ni sertis:', '7102'),

                                                  ('Pierres gemmes (précieuses ou fines) autres que les diamants, même travaillées ou assorties mais non enfilées, ni montées, ni serties; pierres gemmes (précieuses ou fines) autres que les diamants, non assorties, enfilées temporairement pour la facilité du transport:', '7103'),

                                                  ('Pierres synthétiques ou reconstituées, même travaillées ou assorties mais non enfilées ni montées ni serties; pierres synthétiques ou reconstituées non assorties, enfilées temporairement pour la facilité du transport:', '7104'),

                                                  ('Égrisés et poudres de pierres gemmes ou de pierres synthétiques:', '7105'),

                                                  ('Argent (y compris l''argent doré ou vermeil et l''argent platiné), sous formes brutes ou mi-ouvrées, ou en poudre:', '7106'),

                                                  ('Plaqué ou doublé d''argent sur métaux communs, sous formes brutes ou mi-ouvrées', '7107'),

                                                  ('Or (y compris l''or platiné), sous formes brutes ou mi-ouvrées, ou en poudre:', '7108'),

                                                  ('Plaqué ou doublé d''or sur métaux communs ou sur argent, sous formes brutes ou mi-ouvrées', '7109'),

                                                  ('Platine, sous formes brutes ou mi-ouvrées, ou en poudre:', '7110'),

                                                  ('Plaqué ou doublé de platine sur métaux communs, sur argent ou sur or, sous formes brutes ou mi-ouvrées', '7111'),

                                                  ('Déchets et débris de métaux précieux ou de plaqué ou doublé de métaux précieux; autres déchets et débris contenant des métaux précieux ou des composés de métaux précieux du type de ceux utilisés principalement pour la récupération des métaux précieux autres que les produits du n° 8549 :', '7112'),

                                                  ('Articles de bijouterie ou de joaillerie et leurs parties, en métaux précieux ou en plaqués ou doublés de métaux précieux:', '7113'),

                                                  ('Articles d''orfèvrerie et leurs parties, en métaux précieux ou en plaqués ou doublés de métaux précieux:', '7114'),

                                                  ('Autres ouvrages en métaux précieux ou en plaqués ou doublés de métaux précieux:', '7115'),

                                                  ('Ouvrages en perles fines ou de culture, en pierres gemmes ou en pierres synthétiques ou reconstituées:', '7116'),

                                                  ('Bijouterie de fantaisie:', '7117'),

                                                  ('Monnaies:', '7118'),

                                                  ('Fontes brutes et fontes spiegel en gueuses, saumons ou autres formes primaires:', '7201'),

                                                  ('Ferro-alliages:', '7202'),

                                                  ('Produits ferreux obtenus par réduction directe des minerais de fer et autres produits ferreux spongieux, en morceaux, boulettes ou formes similaires; fer d''une pureté minimale en poids de 99,94 %, en morceaux, boulettes ou formes similaires:', '7203'),

                                                  ('Déchets et débris de fonte, de fer ou d''acier (ferrailles); déchets lingotés en fer ou en acier:', '7204'),

                                                  ('Grenailles et poudres de fonte brute, de fonte spiegel, de fer ou d''acier:', '7205'),

                                                  ('Fer et aciers non alliés en lingots ou autres formes primaires, à l''exclusion du fer du no 7203 :', '7206'),

                                                  ('Demi-produits en fer ou en aciers non alliés:', '7207'),

                                                  ('Produits laminés plats, en fer ou en aciers non alliés, d''une largeur de 600 mm ou plus, laminés à chaud, non plaqués ni revêtus:', '7208'),

                                                  ('Produits laminés plats, en fer ou en aciers non alliés, d''une largeur de 600 mm ou plus, laminés à fro

non plaqués ni revêtus:', '7209'),

                                                  ('Produits laminés plats, en fer ou en aciers non alliés, d''une largeur de 600 mm ou plus, plaqués ou revêtus:', '7210'),

                                                  ('Produits laminés plats, en fer ou en aciers non alliés, d''une largeur inférieure à 600 mm, non plaqués ni revêtus:', '7211'),

                                                  ('Produits laminés plats, en fer ou en aciers non alliés, d''une largeur inférieure à 600 mm, plaqués ou revêtus:', '7212'),

                                                  ('Fil machine en fer ou en aciers non alliés:', '7213'),

                                                  ('Barres en fer ou en aciers non alliés, simplement forgées, laminées ou filées à chaud ainsi que celles ayant subi une torsion après laminage:', '7214'),

                                                  ('Autres barres en fer ou en aciers non alliés:', '7215'),

                                                  ('Profilés en fer ou en aciers non alliés:', '7216'),

                                                  ('Fils en fer ou en aciers non alliés:', '7217'),

                                                  ('Aciers inoxydables en lingots ou autres formes primaires; demi-produits en aciers inoxydables:', '7218'),

                                                  ('Produits laminés plats en aciers inoxydables, d''une largeur de 600 mm ou plus:', '7219'),

                                                  ('Produits laminés plats en aciers inoxydables, d''une largeur inférieure à 600 mm:', '7220'),

                                                  ('Fil machine en aciers inoxydables:', '7221'),

                                                  ('Barres et profilés en aciers inoxydables:', '7222'),

                                                  ('Fils en aciers inoxydables:', '7223'),

                                                  ('Autres aciers alliés en lingots ou autres formes primaires; demi-produits en autres aciers alliés:', '7224'),

                                                  ('Produits laminés plats en autres aciers alliés, d''une largeur de 600 mm ou plus:', '7225'),

                                                  ('Produits laminés plats en autres aciers alliés, d''une largeur inférieure à 600 mm:', '7226'),

                                                  ('Fil machine en autres aciers alliés:', '7227'),

                                                  ('Barres et profilés en autres aciers alliés; barres creuses pour le forage en aciers alliés ou non alliés:', '7228'),

                                                  ('Fils en autres aciers alliés:', '7229'),

                                                  ('Palplanches en fer ou en acier, même percées ou faites d''éléments assemblés; profilés obtenus par soudage, en fer ou en acier:', '7301'),

                                                  ('Éléments de voies ferrées, en fonte, fer ou acier: rails, contre-rails et crémaillères, aiguilles, pointes de cœur, tringles d''aiguillage et autres éléments de croisement ou changement de voies, traverses, éclisses, coussinets, coins, selles d''assise, plaques de serrage, plaques et barres d''écartement et autres pièces spécialement conçues pour la pose, le jointement ou la fixation des rails:', '7302'),

                                                  ('Tubes, tuyaux et profilés creux, en fonte:', '7303'),

                                                  ('Tubes, tuyaux et profilés creux, sans soudure, en fer ou en acier:', '7304'),

                                                  ('Autres tubes et tuyaux (soudés ou rivés, par exemple), de section circulaire, d''un diamètre extérieur excédant 406,4 mm, en fer ou en acier:', '7305'),

                                                  ('Autres tubes, tuyaux et profilés creux (soudés, rivés, agrafés ou à bords simplement rapprochés, par exemple), en fer ou en acier:', '7306'),

                                                  ('Accessoires de tuyauterie (raccords, coudes, manchons, par exemple), en fonte, fer ou acier:', '7307'),

                                                  ('Constructions et parties de constructions (ponts et éléments de ponts, portes d''écluses, tours, pylônes, piliers, colonnes, charpentes, toitures, portes et fenêtres et leurs cadres, chambranles et seuils, rideaux de fermeture, balustrades, par exemple), en fonte, fer ou acier, à l''exception des constructions préfabriquées du no 9406 ; tôles, barres, profilés, tubes et similaires, en fonte, fer ou acier, préparés en vue de leur utilisation dans la construction:', '7308'),

                                                  ('Réservoirs, foudres, cuves et récipients similaires pour toutes matières (à l''exception des gaz comprimés ou liquéfiés), en fonte, fer ou acier, d''une contenance excédant 300 l, sans dispositifs mécaniques ou thermiques, même avec revêtement intérieur ou calorifuge:', '7309'),

                                                  ('Réservoirs, fûts, tambours, bidons, boîtes et récipients similaires, pour toutes matières (à l''exception des gaz comprimés ou liquéfiés), en fonte, fer ou acier, d''une contenance n''excédant pas 300 l, sans dispositifs mécaniques ou thermiques, même avec revêtement intérieur ou calorifuge:', '7310'),

                                                  ('Récipients pour gaz comprimés ou liquéfiés, en fonte, fer ou acier:', '7311'),

                                                  ('Torons, câbles, tresses, élingues et articles similaires, en fer ou en acier, non isolés pour l''électricité:', '7312'),

                                                  ('Ronces artificielles en fer ou en acier; torsades, barbelées ou non, en fils ou en feuillard de fer ou d''acier, des types utilisés pour les clôtures', '7313'),

                                                  ('Toiles métalliques (y compris les toiles continues ou sans fin), grillages et treillis, en fils de fer ou d''acier; tôles et bandes déployées, en fer ou en acier:', '7314'),

                                                  ('Chaînes, chaînettes et leurs parties, en fonte, fer ou acier:', '7315'),

                                                  ('Ancres, grappins et leurs parties, en fonte, fer ou acier', '7316'),

                                                  ('Pointes, clous, punaises, crampons appointés, agrafes ondulées ou biseautées et articles similaires, en fonte, fer ou acier, même avec tête en autre matière, à l''exclusion de ceux avec tête en cuivre:', '7317'),

                                                  ('Vis, boulons, écrous, tire-fond, crochets à pas de vis, rivets, goupilles, clavettes, rondelles (y compris les rondelles destinées à faire ressort) et articles similaires, en fonte, fer ou acier:', '7318'),

                                                  ('Aiguilles à coudre, aiguilles à tricoter, passe-lacets, crochets, poinçons à broder et articles similaires, pour usage à la main, en fer ou en acier; épingles de sûreté et autres épingles en fer ou en acier, non dénommées ni comprises ailleurs:', '7319'),

                                                  ('Ressorts et lames de ressorts, en fer ou en acier:', '7320'),

                                                  ('Poêles, chaudières à foyer, cuisinières (y compris ceux pouvant être utilisés accessoirement pour le chauffage central), barbecues, braseros, réchauds à gaz, chauffe-plats et appareils non électriques similaires, à usage domestique, ainsi que leurs parties, en fonte, fer ou acier:', '7321'),

                                                  ('Radiateurs pour le chauffage central, à chauffage non électrique, et leurs parties, en fonte, fer ou acier; générateurs et distributeurs d''air chaud (y compris les distributeurs pouvant également fonctionner comme distributeurs d''air frais ou conditionné), à chauffage non électrique, comportant un ventilateur ou une soufflerie à moteur, et leurs parties, en fonte, fer ou acier:', '7322'),

                                                  ('Articles de ménage ou d''économie domestique et leurs parties, en fonte, fer ou acier; paille de fer ou d''acier; éponges, torchons, gants et articles similaires pour le récurage, le polissage ou usages analogues, en fer ou en acier:', '7323'),

                                                  ('Articles d''hygiène ou de toilette, et leurs parties, en fonte, fer ou acier:', '7324'),

                                                  ('Autres ouvrages moulés en fonte, fer ou acier:', '7325'),

                                                  ('Autres ouvrages en fer ou en acier:', '7326'),

                                                  ('Mattes de cuivre; cuivre de cément (précipité de cuivre)', '7401'),

                                                  ('Cuivre non affiné; anodes en cuivre pour affinage électrolytique', '7402'),

                                                  ('Cuivre affiné et alliages de cuivre sous forme brute:', '7403'),

                                                  ('Déchets et débris de cuivre:', '7404'),

                                                  ('Alliages mères de cuivre', '7405'),

                                                  ('Poudres et paillettes de cuivre:', '7406'),

                                                  ('Barres et profilés en cuivre:', '7407'),

                                                  ('Fils de cuivre:', '7408'),

                                                  ('Tôles et bandes en cuivre, d''une épaisseur excédant 0,15 mm:', '7409'),

                                                  ('Feuilles et bandes minces en cuivre (même imprimées ou fixées sur papier, carton, matière plastique ou supports similaires) d''une épaisseur n''excédant pas 0,15 mm (support non compris):', '7410'),

                                                  ('Tubes et tuyaux en cuivre:', '7411'),

                                                  ('Accessoires de tuyauterie (raccords, coudes, manchons, par exemple), en cuivre:', '7412'),

                                                  ('Torons, câbles, tresses et articles similaires, en cuivre, non isolés pour l''électricité', '7413'),

                                                  ('Pointes, clous, punaises, crampons appointés et articles similaires, en cuivre ou avec tige en fer ou en acier et tête en cuivre; vis, boulons, écrous, crochets à pas de vis, rivets, goupilles, chevilles, clavettes, rondelles (y compris les rondelles destinées à faire ressort) et articles similaires, en cuivre:', '7415'),

                                                  ('Articles de ménage ou d''économie domestique, d''hygiène ou de toilette, et leurs parties, en cuivre; éponges, torchons, gants et articles similaires pour le récurage, le polissage ou usages analogues, en cuivre:', '7418'),

                                                  ('Autres ouvrages en cuivre:', '7419'),

                                                  ('Mattes de nickel, sinters d''oxydes de nickel et autres produits intermédiaires de la métallurgie du nickel:', '7501'),

                                                  ('Nickel sous forme brute:', '7502'),

                                                  ('Déchets et débris de nickel:', '7503'),

                                                  ('Poudres et paillettes de nickel', '7504'),

                                                  ('Barres, profilés et fils, en nickel:', '7505'),

                                                  ('Tôles, bandes et feuilles, en nickel:', '7506'),

                                                  ('Tubes, tuyaux et accessoires de tuyauterie (raccords, coudes, manchons, par exemple), en nickel:', '7507'),

                                                  ('Autres ouvrages en nickel:', '7508'),

                                                  ('Aluminium sous forme brute:', '7601'),

                                                  ('Déchets et débris d''aluminium:', '7602'),

                                                  ('Poudres et paillettes d''aluminium:', '7603'),

                                                  ('Barres et profilés en aluminium:', '7604'),

                                                  ('Fils en aluminium:', '7605'),

                                                  ('Tôles et bandes en aluminium, d''une épaisseur excédant 0,2 mm:', '7606'),

                                                  ('Feuilles et bandes minces en aluminium (même imprimées ou fixées sur papier, carton, matières plastiques ou supports similaires) d''une épaisseur n''excédant pas 0,2 mm (support non compris):', '7607'),

                                                  ('Tubes et tuyaux en aluminium:', '7608'),

                                                  ('Accessoires de tuyauterie (raccords, coudes, manchons, par exemple), en aluminium', '7609'),

                                                  ('Constructions et parties de constructions (ponts et éléments de ponts, tours, pylônes, piliers, colonnes, charpentes, toitures, portes et fenêtres et leurs cadres, chambranles et seuils, balustrades, par exemple), en aluminium, à l''exception des constructions préfabriquées du no 9406 ; tôles, barres, profilés, tubes et similaires, en aluminium, préparés en vue de leur utilisation dans la construction:', '7610'),

                                                  ('Réservoirs, foudres, cuves et récipients similaires pour toutes matières (à l''exception des gaz comprimés ou liquéfiés), en aluminium, d''une contenance excédant 300 l, sans dispositifs mécaniques ou thermiques, même avec revêtement intérieur ou calorifuge', '7611'),

                                                  ('Réservoirs, fûts, tambours, bidons, boîtes et récipients similaires en aluminium (y compris les étuis tubulaires rigides ou souples), pour toutes matières (à l''exception des gaz comprimés ou liquéfiés), d''une contenance n''excédant pas 300 l, sans dispositifs mécaniques ou thermiques, même avec revêtement intérieur ou calorifuge:', '7612'),

                                                  ('Récipients en aluminium pour gaz comprimés ou liquéfiés', '7613'),

                                                  ('Torons, câbles, tresses et similaires, en aluminium, non isolés pour l''électricité:', '7614'),

                                                  ('Articles de ménage ou d''économie domestique, d''hygiène ou de toilette, et leurs parties, en aluminium; éponges, torchons, gants et articles similaires pour le récurage, le polissage ou usages analogues, en aluminium:', '7615'),

                                                  ('Autres ouvrages en aluminium:', '7616'),

                                                  ('Plomb sous forme brute:', '7801'),

                                                  ('Déchets et débris de plomb', '7802'),

                                                  ('Tôles, feuilles et bandes, en plomb; poudres et paillettes de plomb:', '7804'),

                                                  ('Autres ouvrages en plomb:', '7806'),

                                                  ('Zinc sous forme brute:', '7901'),

                                                  ('Déchets et débris de zinc', '7902'),

                                                  ('Poussières, poudres et paillettes, de zinc:', '7903'),

                                                  ('Barres, profilés et fils, en zinc', '7904'),

                                                  ('Tôles, feuilles et bandes, en zinc', '7905'),

                                                  ('Autres ouvrages en zinc', '7907'),

                                                  ('Étain sous forme brute:', '8001'),

                                                  ('Déchets et débris d''étain', '8002'),

                                                  ('Barres, profilés et fils, en étain', '8003'),

                                                  ('Autres ouvrages en étain:', '8007'),

                                                  ('Tungstène (wolfram) et ouvrages en tungstène, y compris les déchets et débris:', '8101'),

                                                  ('Molybdène et ouvrages en molybdène, y compris les déchets et débris:', '8102'),

                                                  ('Tantale et ouvrages en tantale, y compris les déchets et débris:', '8103'),

                                                  ('Magnésium et ouvrages en magnésium, y compris les déchets et débris:', '8104'),

                                                  ('Mattes de cobalt et autres produits intermédiaires de la métallurgie du cobalt; cobalt et ouvrages en cobalt, y compris les déchets et débris:', '8105'),

                                                  ('Bismuth et ouvrages en bismuth, y compris les déchets et débris:', '8106'),

                                                  ('Titane et ouvrages en titane, y compris les déchets et débris:', '8108'),

                                                  ('Zirconium et ouvrages en zirconium, y compris les déchets et débris:', '8109'),

                                                  ('Antimoine et ouvrages en antimoine, y compris les déchets et débris:', '8110'),

                                                  ('Manganèse et ouvrages en manganèse, y compris les déchets et débris:', '8111'),

                                                  ('Béryllium, chrome, hafnium (celtium), rhénium, thallium, cadmium, germanium, vanadium, gallium, indium et niobium (columbium), ainsi que les ouvrages en ces métaux, y compris les déchets et débris:', '8112'),

                                                  ('Cermets et ouvrages en cermets, y compris les déchets et débris:', '8113'),

                                                  ('Bêches, pelles, pioches, pics, houes, binettes, fourches, râteaux et racloirs; haches, serpes et outils similaires à taillants; sécateurs de tous types; faux et faucilles, couteaux à foin ou à paille, cisailles à haies, coins et autres outils agricoles, horticoles ou forestiers, à main:', '8201'),

                                                  ('Scies à main; lames de scies de toutes sortes (y compris les fraises-scies et les lames non dentées pour le sciage):', '8202'),

                                                  ('Limes, râpes, pinces (même coupantes), tenailles, brucelles, cisailles à métaux, coupe-tubes, coupe-boulons, emporte-pièce et outils similaires, à main:', '8203'),

                                                  ('Clés de serrage à main (y compris les clés dynamométriques); douilles de serrage interchangeables, même avec manches:', '8204'),

                                                  ('Outils et outillage à main (y compris les diamants de vitriers) non dénommés ni compris ailleurs; lampes à souder et similaires; étaux, serre-joints et similaires, autres que ceux constituant des accessoires ou des parties de machines-outils ou de machines à découper par jet d''eau; enclumes; forges portatives; meules avec bâtis, à main ou à pédale:', '8205'),

                                                  ('Outils d''au moins deux des nos 8202  à 8205 , conditionnés en assortiments pour la vente au détail', '8206'),

                                                  ('Outils interchangeables pour outillage à main, mécanique ou non, ou pour machines-outils (à emboutir, à estamper, à poinçonner, à tarauder, à fileter, à percer, à aléser, à brocher, à fraiser, à tourner, à visser, par exemple), y compris les filières pour l''étirage ou le filage (extrusion) des métaux, ainsi que les outils de forage ou de sondage:', '8207'),

                                                  ('Couteaux et lames tranchantes, pour machines ou pour appareils mécaniques:', '8208'),

                                                  ('Plaquettes, baguettes, pointes et objets similaires pour outils, non montés, constitués par des cermets:', '8209'),

                                                  ('Appareils mécaniques actionnés à la main, d''un poids de 10 kg ou moins, utilisés pour préparer, conditionner ou servir les aliments ou les boissons', '8210'),

                                                  ('Couteaux (autres que ceux du no 8208 ) à lame tranchante ou dentelée, y compris les serpettes fermantes, et leurs lames:', '8211'),

                                                  ('Rasoirs et leurs lames (y compris les ébauches en bandes):', '8212'),

                                                  ('Ciseaux à doubles branches et leurs lames', '8213'),

                                                  ('Autres articles de coutellerie (tondeuses, fendoirs, couperets, hachoirs de bouchers ou de cuisine et coupe-papier, par exemple); outils et assortiments d''outils de manucures ou de pédicures (y compris les limes à ongles):', '8214'),

                                                  ('Cuillers, fourchettes, louches, écumoires, pelles à tartes, couteaux spéciaux à poisson ou à beurre, pinces à sucre et articles similaires:', '8215'),

                                                  ('Cadenas, serrures et verrous (à clef, à secret ou électriques), en métaux communs; fermoirs et montures-fermoirs comportant une serrure, en métaux communs; clefs pour ces articles, en métaux communs:', '8301'),

                                                  ('Garnitures, ferrures et articles similaires en métaux communs pour meubles, portes, escaliers, fenêtres, persiennes, carrosseries, articles de sellerie, malles, coffres, coffrets ou autres ouvrages de l''espèce; patères, porte-chapeaux, supports et articles similaires, en métaux communs; roulettes avec monture en métaux communs; ferme-portes automatiques en métaux communs:', '8302'),

                                                  ('Coffres-forts, portes blindées et compartiments pour chambres fortes, coffres et cassettes de sûreté et articles similaires, en métaux communs:', '8303'),

                                                  ('Classeurs, fichiers, boîtes de classement, porte-copies, plumiers, porte-cachets et matériel et fournitures similaires de bureau, en métaux communs, à l''exclusion des meubles de bureau du no 9403', '8304'),

                                                  ('Mécanismes pour reliure de feuillets mobiles ou pour classeurs, attache-lettres, coins de lettres, trombones, onglets de signalisation et objets similaires de bureau, en métaux communs; agrafes présentées en barrettes (de bureau, pour tapissiers, emballeurs, par exemple), en métaux communs:', '8305'),

                                                  ('Cloches, sonnettes, gongs et articles similaires, non électriques, en métaux communs; statuettes et autres objets d''ornement, en métaux communs; cadres pour photographies, gravures ou similaires, en métaux communs; miroirs en métaux communs:', '8306'),

                                                  ('Tuyaux flexibles en métaux communs, même avec leurs accessoires:', '8307'),

                                                  ('Fermoirs, montures-fermoirs, boucles, boucles-fermoirs, agrafes, crochets, oeillets et articles similaires, en métaux communs, pour vêtements ou accessoires du vêtement, chaussures, bijouterie, bracelets-montres, livres, bâches, maroquinerie, sellerie, articles de voyage ou pour toutes confections; rivets tubulaires ou à tige fendue, en métaux communs; perles et paillettes découpées, en métaux communs:', '8308'),

                                                  ('Bouchons (y compris les bouchons-couronnes, les bouchons à pas de vis et les bouchons-verseurs), couvercles, capsules pour bouteilles, bondes filetées, plaques de bondes, scellés et autres accessoires pour l''emballage, en métaux communs:', '8309'),

                                                  ('Plaques indicatrices, plaques-enseignes, plaques-adresses et plaques similaires, chiffres, lettres et enseignes diverses, en métaux communs, à l''exclusion de ceux du no 9405', '8310'),

                                                  ('Fils, baguettes, tubes, plaques, électrodes et articles similaires, en métaux communs ou en carbures métalliques, enrobés ou fourrés de décapants ou de fondants, pour brasage, soudage ou dépôt de métal ou de carbures métalliques; fils et baguettes en poudres de métaux communs agglomérés, pour la métallisation par projection:', '8311'),

                                                  ('Réacteurs nucléaires; éléments combustibles (cartouches) non irradiés pour réacteurs nucléaires; machines et appareils pour la séparation isotopique:', '8401'),

                                                  ('Chaudières à vapeur (générateurs de vapeur), autres que les chaudières pour le chauffage central conçues pour produire à la fois de l''eau chaude et de la vapeur à basse pression; chaudières dites «à eau surchauffée»:', '8402'),

                                                  ('Chaudières pour le chauffage central autres que celles du no 8402 :', '8403'),

                                                  ('Appareils auxiliaires pour chaudières des nos 8402  ou 8403  (économiseurs, surchauffeurs, appareils de ramonage ou de récupération des gaz, par exemple); condenseurs pour machines à vapeur:', '8404'),

                                                  ('Générateurs de gaz à l''air ou de gaz à l''eau, avec ou sans leurs épurateurs; générateurs d''acétylène et générateurs similaires de gaz, par procédé à l''eau, avec ou sans leurs épurateurs:', '8405'),

                                                  ('Turbines à vapeur:', '8406'),

                                                  ('Moteurs à piston alternatif ou rotatif, à allumage par étincelles (moteurs à explosion):', '8407'),

                                                  ('Moteurs à piston, à allumage par compression (moteur diesel ou semi-diesel):', '8408'),

                                                  ('Parties reconnaissables comme étant exclusivement ou principalement destinées aux moteurs des nos 8407  ou 8408 :', '8409'),

                                                  ('Turbines hydrauliques, roues hydrauliques et leurs régulateurs:', '8410'),

                                                  ('Turboréacteurs, turbopropulseurs et autres turbines à gaz:', '8411'),

                                                  ('Autres moteurs et machines motrices:', '8412'),

                                                  ('Pompes pour liquides, même comportant un dispositif mesureur; élévateurs à liquides:', '8413'),

                                                  ('Pompes à air ou à vide, compresseurs d''air ou d''autres gaz et ventilateurs; hottes aspirantes à extraction ou à recyclage, à ventilateur incorporé, même filtrantes; enceintes de sécurité biologique étanches aux gaz, même filtrantes:', '8414'),

                                                  ('Machines et appareils pour le conditionnement de l''air comprenant un ventilateur à moteur et des dispositifs propres à modifier la température et l''humidité, y compris ceux dans lesquels le degré hygrométrique n''est pas réglable séparément:', '8415'),

                                                  ('Brûleurs pour l''alimentation des foyers, à combustibles liquides, à combustibles solides pulvérisés ou à gaz; foyers automatiques, y compris leurs avant-foyers, leurs grilles mécaniques, leurs dispositifs mécaniques pour l''évacuation des cendres et dispositifs similaires:', '8416'),

                                                  ('Fours industriels ou de laboratoires, y compris les incinérateurs, non électriques:', '8417'),

                                                  ('Réfrigérateurs, congélateurs-conservateurs et autres matériel, machines et appareils pour la production du fro

à équipement électrique ou autre; pompes à chaleur autres que les machines et appareils pour le conditionnement de l''air du no 8415 :', '8418'),

                                                  ('Appareils, dispositifs ou équipements de laboratoire, même chauffés électriquement (à l''exclusion des fours et autres appareils du no 8514 ), pour le traitement de matières par des opérations impliquant un changement de température telles que le chauffage, la cuisson, la torréfaction, la distillation, la rectification, la stérilisation, la pasteurisation, l''étuvage, le séchage, l''évaporation, la vaporisation, la condensation ou le refroidissement, autres que les appareils domestiques; chauffe-eau non électriques, à chauffage instantané ou à accumulation:', '8419'),

                                                  ('Calandres et laminoirs, autres que pour les métaux ou le verre, et cylindres pour ces machines:', '8420'),

                                                  ('Centrifugeuses, y compris les essoreuses centrifuges; appareils pour la filtration ou l''épuration des liquides ou des gaz:', '8421'),

                                                  ('Machines à laver la vaisselle; machines et appareils servant à nettoyer ou à sécher les bouteilles ou autres récipients; machines et appareils à remplir, fermer, boucher ou étiqueter les bouteilles, boîtes, sacs ou autres contenants; machines et appareils à capsuler les bouteilles, pots, tubes et contenants analogues; autres machines et appareils à empaqueter ou à emballer les marchandises (y compris les machines et appareils à emballer sous film thermorétractable); machines et appareils à gazéifier les boissons:', '8422'),

                                                  ('Appareils et instruments de pesage, y compris les bascules et balances à vérifier les pièces usinées, mais à l''exclusion des balances sensibles à un poids de 5 cg ou moins; poids pour toutes balances:', '8423'),

                                                  ('Appareils mécaniques (même à main) à projeter, disperser ou pulvériser des matières liquides ou en poudre; extincteurs, même chargés; pistolets aérographes et appareils similaires; machines et appareils à jet de sable, à jet de vapeur et appareils à jet similaires:', '8424'),

                                                  ('Palans; treuils et cabestans; crics et vérins:', '8425'),

                                                  ('Bigues; grues et blondins; ponts roulants, portiques de déchargement ou de manutention, ponts-grues, chariots-cavaliers et chariots-grues:', '8426'),

                                                  ('Chariots-gerbeurs; autres chariots de manutention munis d''un dispositif de levage:', '8427'),

                                                  ('Autres machines et appareils de levage, de chargement, de déchargement ou de manutention (ascenseurs, escaliers mécaniques, transporteurs, téléphériques, par exemple):', '8428'),

                                                  ('Bouteurs (bulldozers), bouteurs biais (angledozers), niveleuses, décapeuses (scrapers), pelles mécaniques, excavateurs, chargeuses et chargeuses-pelleteuses, compacteuses et rouleaux compresseurs, autopropulsés:', '8429'),

                                                  ('Autres machines et appareils de terrassement, nivellement, décapage, excavation, compactage, extraction ou forage de la terre, des minéraux ou des minerais; sonnettes de battage et machines pour l''arrachage des pieux; chasse-neige:', '8430'),

                                                  ('Parties reconnaissables comme étant exclusivement ou principalement destinées aux machines ou appareils des nos 8425  à 8430 :', '8431'),

                                                  ('Machines, appareils et engins agricoles, horticoles ou sylvicoles pour la préparation ou le travail du sol ou pour la culture; rouleaux pour pelouses ou terrains de sport:', '8432'),

                                                  ('Machines, appareils et engins pour la récolte et le battage des produits agricoles, y compris les presses à paille ou à fourrage; tondeuses à gazon et faucheuses; machines pour le nettoyage ou le triage des œufs, fruits ou autres produits agricoles, autres que les machines et appareils du no 8437 :', '8433'),

                                                  ('Machines à traire et machines et appareils de laiterie:', '8434'),

                                                  ('Presses et pressoirs, fouloirs et machines et appareils analogues pour la fabrication du vin, du cidre, des jus de fruits ou de boissons similaires:', '8435'),

                                                  ('Autres machines et appareils pour l''agriculture, l''horticulture, la sylviculture, l''aviculture ou l''apiculture, y compris les germoirs comportant des dispositifs mécaniques ou thermiques et les couveuses et éleveuses pour l''aviculture:', '8436'),

                                                  ('Machines pour le nettoyage, le triage ou le criblage des grains ou des légumes secs; machines et appareils pour la minoterie ou le traitement des céréales ou légumes secs, autres que les machines et appareils du type fermier:', '8437'),

                                                  ('Machines et appareils, non dénommés ni compris ailleurs dans le présent chapitre, pour la préparation ou la fabrication industrielles d''aliments ou de boissons, autres que les machines et appareils pour l''extraction ou la préparation des huiles ou graisses végétales ou d’origine microbienne fixes ou animales:', '8438'),

                                                  ('Machines et appareils pour la fabrication de la pâte de matières fibreuses cellulosiques ou pour la fabrication ou le finissage du papier ou du carton:', '8439'),

                                                  ('Machines et appareils pour le brochage ou la reliure, y compris les machines à coudre les feuillets:', '8440'),

                                                  ('Autres machines et appareils pour le travail de la pâte à papier, du papier ou du carton, y compris les coupeuses de tous types:', '8441'),

                                                  ('Machines, appareils et matériels (autres que les machines des nos8456  à 8465 ) pour la préparation ou la fabrication des clichés, planches, cylindres ou autres organes imprimants; clichés, planches, cylindres et autres organes imprimants; pierres lithographiques, planches, plaques et cylindres préparés pour l’impression (planés, grenés, polis, par exemple):', '8442'),

                                                  ('Machines et appareils servant à l’impression au moyen de planches, cylindres et autres organes imprimants du no 8442 ; autres imprimantes, machines à copier et machines à télécopier, même combinées entre elles; parties et accessoires:', '8443'),

                                                  ('Machines pour le filage (extrusion), l''étirage, la texturation ou le tranchage des matières textiles synthétiques ou artificielles:', '8444'),

                                                  ('Machines pour la préparation des matières textiles; machines pour la filature, le doublage ou le retordage des matières textiles et autres machines et appareils pour la fabrication des fils textiles; machines à bobiner (y compris les canetières) ou à dévider les matières textiles et machines pour la préparation des fils textiles en vue de leur utilisation sur les machines des nos 8446  ou 8447 :', '8445'),

                                                  ('Métiers à tisser:', '8446'),

                                                  ('Machines et métiers à bonneterie, de couture-tricotage, à guipure, à tulle, à dentelle, à broderie, à passementerie, à tresses, à filet ou à touffeter:', '8447'),

                                                  ('Machines et appareils auxiliaires pour les machines des nos 8444 , 8445 , 8446  ou 8447  (ratières, mécaniques Jacquard, casse-chaînes et casse-trames, mécanismes de changement de navettes, par exemple); parties et accessoires reconnaissables comme étant exclusivement ou principalement destinés aux machines de la présente position ou des nos 8444 , 8445 , 8446  ou 8447  (broches, ailettes, garnitures de cardes, peignes, barrettes, filières, navettes, lisses et cadres de lisses, aiguilles, platines, crochets, par exemple):', '8448'),

                                                  ('Machines et appareils pour la fabrication ou le finissage du feutre ou des nontissés, en pièce ou en forme, y compris les machines et appareils pour la fabrication de chapeaux en feutre; formes de chapellerie', '8449'),

                                                  ('Machines à laver le linge, même avec dispositif de séchage:', '8450'),

                                                  ('Machines et appareils (autres que les machines du no 8450 ) pour le lavage, le nettoyage, l''essorage, le séchage, le repassage, le pressage (y compris les presses à fixer), le blanchiment, la teinture, l''apprêt, le finissage, l''enduction ou l''imprégnation des fils, tissus ou ouvrages en matières textiles et machines pour le revêtement des tissus ou autres supports utilisés pour la fabrication de couvre-parquets tels que le linoléum; machines à enrouler, dérouler, plier, couper ou denteler les tissus:', '8451'),

                                                  ('Machines à coudre, autres que les machines à coudre les feuillets du no 8440 ; meubles, embases et couvercles spécialement conçus pour machines à coudre; aiguilles pour machines à coudre:', '8452'),

                                                  ('Machines et appareils pour la préparation, le tannage ou le travail des cuirs ou peaux ou pour la fabrication ou la réparation des chaussures ou autres ouvrages en cuir ou en peau, autres que les machines à coudre:', '8453'),

                                                  ('Convertisseurs, poches de coulée, lingotières et machines à couler (mouler) pour métallurgie, aciérie ou fonderie:', '8454'),

                                                  ('Laminoirs à métaux et leurs cylindres:', '8455'),

                                                  ('Machines-outils travaillant par enlèvement de toute matière et opérant par laser ou autre faisceau de lumière ou de photons, par ultrasons, par électro-érosion, par procédés électrochimiques, par faisceaux d''électrons, par faisceaux ioniques ou par jet de plasma; machines à découper par jet d''eau:', '8456'),

                                                  ('Centres d''usinage, machines à poste fixe et machines à stations multiples, pour le travail des métaux:', '8457'),

                                                  ('Tours (y compris les centres de tournage) travaillant par enlèvement de métal:', '8458'),

                                                  ('Machines (y compris les unités d''usinage à glissières) à percer, aléser, fraiser, fileter ou tarauder les métaux par enlèvement de matière, autres que les tours (y compris les centres de tournage) du no 8458 :', '8459'),

                                                  ('Machines à ébarber, affûter, meuler, rectifier, roder, polir ou à faire d''autres opérations de finissage, travaillant des métaux ou des cermets à l''aide de meules, d''abrasifs ou de produits de polissage, autres que les machines à tailler ou à finir les engrenages du no 8461 :', '8460'),

                                                  ('Machines à raboter, étaux-limeurs, machines à mortaiser, brocher, tailler les engrenages, finir les engrenages, scier, tronçonner et autres machines-outils travaillant par enlèvement de métal ou de cermets, non dénommées ni comprises ailleurs:', '8461'),

                                                  ('Machines (y compris les presses) à forger ou à estamper, moutons, marteaux-pilons et martinets pour le travail des métaux (à l’exclusion des laminoirs); machines (y compris les presses, les lignes de refendage et les lignes de découpe à longueur) à rouler, cintrer, plier, dresser, planer, cisailler, poinçonner, gruger ou à grignoter les métaux (à l’exclusion des bancs à étirer); presses pour le travail des métaux ou des carbures métalliques, autres que celles visées ci-dessus:', '8462'),

                                                  ('Autres machines-outils pour le travail des métaux ou des cermets, travaillant sans enlèvement de matière:', '8463'),

                                                  ('Machines-outils pour le travail de la pierre, des produits céramiques, du béton, de l''amiante-ciment ou de matières minérales similaires, ou pour le travail à froid du verre:', '8464'),

                                                  ('Machines-outils (y compris les machines à clouer, agrafer, coller ou autrement assembler) pour le travail du bois, du liège, de l''os, du caoutchouc durci, des matières plastiques dures ou matières dures similaires:', '8465'),

                                                  ('Parties et accessoires reconnaissables comme étant exclusivement ou principalement destinés aux machines des nos8456  à 8465 , y compris les porte-pièces et porte-outils, les filières à déclenchement automatique, les dispositifs diviseurs et autres dispositifs spéciaux se montant sur ces machines; porte-outils pour outils ou outillage à main, de tous types:', '8466'),

                                                  ('Outils pneumatiques, hydrauliques ou à moteur (électrique ou non électrique) incorporé, pour emploi à la main:', '8467'),

                                                  ('Machines et appareils pour le brasage ou le soudage, même pouvant couper, autres que ceux du no 8515 ; machines et appareils aux gaz pour la trempe superficielle:', '8468'),

                                                  ('Machines à calculer et machines de poche permettant d''enregistrer, de reproduire et d''afficher des informations, comportant une fonction de calcul; machines comptables, machines à affranchir, à établir les tickets et machines similaires, comportant un dispositif de calcul; caisses enregistreuses:', '8470'),

                                                  ('Machines automatiques de traitement de l''information et leurs unités; lecteurs magnétiques ou optiques, machines de mise d''informations sur support sous forme codée et machines de traitement de ces informations, non dénommés ni compris ailleurs:', '8471'),

                                                  ('Autres machines et appareils de bureau (duplicateurs hectographiques ou à stencils, machines à imprimer les adresses, distributeurs automatiques de billets de banque, machines à trier, à compter ou à encartoucher les pièces de monnaie, appareils à tailler les crayons, appareils à perforer ou à agrafer, par exemple):', '8472'),

                                                  ('Parties et accessoires (autres que les coffrets, housses et similaires) reconnaissables comme étant exclusivement ou principalement destinés aux machines ou appareils des nos 8470  à 8472 :', '8473'),

                                                  ('Machines et appareils à trier, cribler, séparer, laver, concasser, broyer, mélanger ou malaxer les terres, pierres, minerais ou autres matières minérales solides (y compris les poudres et les pâtes); machines à agglomérer, former ou mouler les combustibles minéraux solides, les pâtes céramiques, le ciment, le plâtre ou autres matières minérales en poudre ou en pâte; machines à former les moules de fonderie en sable:', '8474'),

                                                  ('Machines pour l''assemblage des lampes, tubes ou valves électriques ou électroniques ou des lampes pour la production de la lumière-éclair, qui comportent une enveloppe en verre; machines pour la fabrication ou le travail à chaud du verre ou des ouvrages en verre:', '8475'),

                                                  ('Machines automatiques de vente de produits (timbres-poste, cigarettes, denrées alimentaires, boissons, par exemple), y compris les machines pour changer la monnaie:', '8476'),

                                                  ('Machines et appareils pour le travail du caoutchouc ou des matières plastiques ou pour la fabrication de produits en ces matières, non dénommés ni compris ailleurs dans le présent chapitre:', '8477'),

                                                  ('Machines et appareils pour la préparation ou la transformation du tabac, non dénommés ni compris ailleurs dans le présent chapitre:', '8478'),

                                                  ('Machines et appareils mécaniques ayant une fonction propre, non dénommés ni compris ailleurs dans le présent chapitre:', '8479'),

                                                  ('Châssis de fonderie; plaques de fond pour moules; modèles pour moules; moules pour les métaux (autres que les lingotières), les carbures métalliques, le verre, les matières minérales, le caoutchouc ou les matières plastiques:', '8480'),

                                                  ('Articles de robinetterie et organes similaires pour tuyauteries, chaudières, réservoirs, cuves ou contenants similaires, y compris les détendeurs et les vannes thermostatiques:', '8481'),

                                                  ('Roulements à billes, à galets, à rouleaux ou à aiguilles:', '8482'),

                                                  ('Arbres de transmission (y compris les arbres à cames et les vilebrequins) et manivelles; paliers et coussinets; engrenages et roues de friction; broches filetées à billes ou à rouleaux; réducteurs, multiplicateurs et variateurs de vitesse, y compris les convertisseurs de couple; volants et poulies, y compris les poulies à moufles; embrayages et organes d''accouplement, y compris les joints d''articulation:', '8483'),

                                                  ('Joints métalloplastiques; jeux ou assortiments de joints de composition différente présentés en pochettes, enveloppes ou emballages analogues; joints d''étanchéité mécaniques:', '8484'),

                                                  ('Machines pour la fabrication additive:', '8485'),

                                                  ('Machines et appareils utilisés exclusivement ou principalement pour la fabrication des lingots, des plaquettes ou des dispositifs à semi-conducteur, des circuits intégrés électroniques ou des dispositifs d''affichage à écran plat; machines et appareils visés à la note 11 C) du présent chapitre; parties et accessoires:', '8486'),

                                                  ('Parties de machines ou d''appareils, non dénommées ni comprises ailleurs dans le présent chapitre, ne comportant pas de connexions électriques, de parties isolées électriquement, de bobinages, de contacts ni d''autres caractéristiques électriques:', '8487'),

                                                  ('Moteurs et machines génératrices, électriques, à l''exclusion des groupes électrogènes:', '8501'),

                                                  ('Groupes électrogènes et convertisseurs rotatifs électriques:', '8502'),

                                                  ('Parties reconnaissables comme étant exclusivement ou principalement destinées aux machines des nos 8501  ou 8502 :', '8503'),

                                                  ('Transformateurs électriques, convertisseurs électriques statiques (redresseurs, par exemple), bobines de réactance et selfs:', '8504'),

                                                  ('Électro-aimants; aimants permanents et articles destinés à devenir des aimants permanents après aimantation; plateaux, mandrins et dispositifs magnétiques ou électromagnétiques similaires de fixation; accouplements, embrayages, variateurs de vitesse et freins électromagnétiques; têtes de levage électromagnétiques:', '8505'),

                                                  ('Piles et batteries de piles électriques:', '8506'),

                                                  ('Accumulateurs électriques, y compris leurs séparateurs, même de forme carrée ou rectangulaire:', '8507'),

                                                  ('Aspirateurs:', '8508'),

                                                  ('Appareils électromécaniques à moteur électrique incorporé, à usage domestique, autres que les aspirateurs du no 8508 :', '8509'),

                                                  ('Rasoirs, tondeuses et appareils à épiler, à moteur électrique incorporé:', '8510'),

                                                  ('Appareils et dispositifs électriques d''allumage ou de démarrage pour moteurs à allumage par étincelles ou par compression (magnétos, dynamos-magnétos, bobines d''allumage, bougies d''allumage ou de chauffage, démarreurs, par exemple); génératrices (dynamos, alternateurs, par exemple) et conjoncteurs-disjoncteurs utilisés avec ces moteurs:', '8511'),

                                                  ('Appareils électriques d''éclairage ou de signalisation (à l''exclusion des articles du no 8539 ), essuie-glaces, dégivreurs et dispositifs antibuée électriques, des types utilisés pour cycles ou automobiles:', '8512'),

                                                  ('Lampes électriques portatives, conçues pour fonctionner au moyen de leur propre source d''énergie (à piles, à accumulateurs, électromagnétiques, par exemple), autres que les appareils d''éclairage du no 8512 :', '8513'),

                                                  ('Fours électriques industriels ou de laboratoires, y compris ceux fonctionnant par induction ou par pertes diélectriques; autres appareils industriels ou de laboratoires pour le traitement thermique des matières par induction ou par pertes diélectriques:', '8514'),

                                                  ('Machines et appareils pour le brasage ou le soudage (même pouvant couper), électriques (y compris ceux aux gaz chauffés électriquement) ou opérant par laser ou autres faisceaux de lumière ou de photons, par ultrasons, par faisceaux d''électrons, par impulsions magnétiques ou au jet de plasma; machines et appareils électriques pour la projection à chaud de métaux ou de cermets:', '8515'),

                                                  ('Chauffe-eau et thermoplongeurs électriques; appareils électriques pour le chauffage des locaux, du sol ou pour usages similaires; appareils électrothermiques pour la coiffure (sèche-cheveux, appareils à friser, chauffe-fers à friser, par exemple) ou pour sécher les mains; fers à repasser électriques; autres appareils électrothermiques pour usages domestiques; résistances chauffantes, autres que celles du no 8545 :', '8516'),

                                                  ('Postes téléphoniques d’usagers, y compris les téléphones intelligents et autres téléphones pour réseaux cellulaires et pour autres réseaux sans fil; autres appareils pour l''émission, la transmission ou la réception de la voix, d’images ou d''autres données, y compris les appareils pour la communication dans un réseau filaire ou sans fil (tel qu''un réseau local ou étendu), autres que ceux des nos 8443 , 8525 , 8527  ou 8528 :', '8517'),

                                                  ('Microphones et leurs supports; haut-parleurs, même montés dans leurs enceintes; casques d''écoute et écouteurs, même combinés avec un microphone, et ensembles ou assortiments constitués par un microphone et un ou plusieurs haut-parleurs; amplificateurs électriques d''audiofréquence; appareils électriques d''amplification du son:', '8518'),

                                                  ('Appareils d''enregistrement du son; appareils de reproduction du son; appareils d''enregistrement et de reproduction du son:', '8519'),

                                                  ('Appareils d''enregistrement ou de reproduction vidéophoniques, même incorporant un récepteur de signaux vidéophoniques:', '8521'),

                                                  ('Parties et accessoires reconnaissables comme étant exclusivement ou principalement destinés aux appareils des nos 8519  ou 8521 :', '8522'),

                                                  ('Disques, bandes, dispositifs de stockage rémanent des données à base de semi-conducteurs, «cartes intelligentes» et autres supports pour l''enregistrement du son ou pour enregistrements analogues, mêmes enregistrés, y compris les matrices et moules galvaniques pour la fabrication des disques, à l''exclusion des produits du chapitre 37:', '8523'),

                                                  ('Modules d’affichage à écran plat, même comprenant des écrans tactiles:', '8524'),

                                                  ('Appareils d''émission pour la radiodiffusion ou la télévision, même incorporant un appareil de réception ou un appareil d''enregistrement ou de reproduction du son; caméras de télévision, appareils photographiques numériques et caméscopes:', '8525'),

                                                  ('Appareils de radiodétection et de radiosondage (radar), appareils de radionavigation et appareils de radiotélécommande:', '8526'),

                                                  ('Appareils récepteurs pour la radiodiffusion, même combinés, sous une même enveloppe, à un appareil d''enregistrement ou de reproduction du son ou à un appareil d''horlogerie:', '8527'),

                                                  ('Moniteurs et projecteurs, n''incorporant pas d''appareil de réception de télévision; appareils récepteurs de télévision, même incorporant un appareil récepteur de radiodiffusion ou un appareil d''enregistrement ou de reproduction du son ou des images:', '8528'),

                                                  ('Parties reconnaissables comme étant exclusivement ou principalement destinées aux appareils des nos 8524  à 8528 :', '8529'),

                                                  ('Appareils électriques de signalisation (autres que pour la transmission de messages), de sécurité, de contrôle ou de commande pour voies ferrées ou similaires, voies routières ou fluviales, aires ou parcs de stationnement, installations portuaires ou aérodromes (autres que ceux du no 8608 ):', '8530'),

                                                  ('Appareils électriques de signalisation acoustique ou visuelle (sonneries, sirènes, tableaux annonciateurs, appareils avertisseurs pour la protection contre le vol ou l''incendie, par exemple), autres que ceux des nos 8512  ou 8530 :', '8531'),

                                                  ('Condensateurs électriques, fixes, variables ou ajustables:', '8532'),

                                                  ('Résistances électriques non chauffantes (y compris les rhéostats et les potentiomètres):', '8533'),

                                                  ('Circuits imprimés:', '8534'),

                                                  ('Appareillage pour la coupure, le sectionnement, la protection, le branchement, le raccordement ou la connexion des circuits électriques (interrupteurs, commutateurs, coupe-circuit, parafoudres, limiteurs de tension, parasurtenseurs, prises de courant et autres connecteurs, boîtes de jonction, par exemple), pour une tension excédant 1 000  V:', '8535'),

                                                  ('Appareillage pour la coupure, le sectionnement, la protection, le branchement, le raccordement ou la connexion des circuits électriques (interrupteurs, commutateurs, relais, coupe-circuit, parasurtenseurs, fiches et prises de courant, douilles pour lampes et autres connecteurs, boîtes de jonction, par exemple), pour une tension n''excédant pas 1 000  V; connecteurs pour fibres optiques, faisceaux ou câbles de fibres optiques:', '8536'),

                                                  ('Tableaux, panneaux, consoles, pupitres, armoires et autres supports comportant plusieurs appareils des nos 8535  ou 8536 , pour la commande ou la distribution électrique, y compris ceux incorporant des instruments ou appareils du chapitre 90 ainsi que les appareils de commande numérique, autres que les appareils de commutation du no 8517 :', '8537'),

                                                  ('Parties reconnaissables comme étant exclusivement ou principalement destinées aux appareils des nos 8535 , 8536  ou 8537 :', '8538'),

                                                  ('Lampes et tubes électriques à incandescence ou à décharge, y compris les articles dits «phares et projecteurs scellés» et les lampes et tubes à rayons ultraviolets ou infrarouges; lampes à arc; sources lumineuses à diodes émettrices de lumière (LED):', '8539'),

                                                  ('Lampes, tubes et valves électroniques à cathode chaude, à cathode froide ou à photocathode (lampes, tubes et valves à vide, à vapeur ou à gaz, tubes redresseurs à vapeur de mercure, tubes cathodiques, tubes et valves pour caméras de télévision, par exemple), autres que ceux du no 8539 :', '8540'),

                                                  ('Dispositifs à semi-conducteur (par exemple, diodes, transistors, transducteurs à semiconducteur); dispositifs photosensibles à semi-conducteur, y compris les cellules photovoltaïques même assemblées en modules ou constituées en panneaux; diodes émettrices de lumière (LED), même assemblées avec d’autres diodes émettrices de lumière (LED); cristaux piézo-électriques montés:', '8541'),

                                                  ('Circuits intégrés électroniques:', '8542'),

                                                  ('Machines et appareils électriques ayant une fonction propre, non dénommés ni compris ailleurs dans le présent chapitre:', '8543'),

                                                  ('Fils, câbles (y compris les câbles coaxiaux) et autres conducteurs isolés pour l''électricité (même laqués ou oxydés anodiquement), munis ou non de pièces de connexion; câbles de fibres optiques, constitués de fibres gainées individuellement, même comportant des conducteurs électriques ou munis de pièces de connexion:', '8544'),

                                                  ('Électrodes en charbon, balais en charbon, charbons pour lampes ou pour piles et autres articles en graphite ou en autre carbone, avec ou sans métal, pour usages électriques:', '8545'),

                                                  ('Isolateurs en toutes matières pour l''électricité:', '8546'),

                                                  ('Pièces isolantes, entièrement en matières isolantes ou comportant de simples pièces métalliques d''assemblage (douilles à pas de vis, par exemple) noyées dans la masse, pour machines, appareils ou installations électriques, autres que les isolateurs du no 8546 ; tubes isolateurs et leurs pièces de raccordement, en métaux communs, isolés intérieurement:', '8547'),

                                                  ('Parties électriques de machines ou d’appareils, non dénommées ni comprises ailleurs dans le présent chapitre:', '8548'),

                                                  ('Déchets et débris électriques et électroniques:', '8549'),

                                                  ('Locomotives et locotracteurs, à source extérieure d''électricité ou à accumulateurs électriques:', '8601'),

                                                  ('Autres locomotives et locotracteurs; tenders:', '8602'),

                                                  ('Automotrices et autorails, autres que ceux du no 8604 :', '8603'),

                                                  ('Véhicules pour l''entretien ou le service des voies ferrées ou similaires, même autopropulsés (wagons-ateliers, wagons-grues, wagons équipés de bourreuses à ballast, aligneuses pour voies, voitures d''essais et draisines, par exemple)', '8604'),

                                                  ('Voitures à voyageurs, fourgons à bagages, voitures postales et autres voitures spéciales, pour voies ferrées ou similaires (à l''exclusion des voitures du no 8604 )', '8605'),

                                                  ('Wagons pour le transport sur rail de marchandises:', '8606'),

                                                  ('Parties de véhicules pour voies ferrées ou similaires:', '8607'),

                                                  ('Matériel fixe de voies ferrées ou similaires; appareils mécaniques (y compris électromécaniques) de signalisation, de sécurité, de contrôle ou de commande pour voies ferrées ou similaires, routières ou fluviales, aires ou parcs de stationnement, installations portuaires ou aérodromes; leurs parties', '8608'),

                                                  ('Cadres et conteneurs (y compris les conteneurs-citernes et les conteneurs-réservoirs) spécialement conçus et équipés pour un ou plusieurs modes de transport:', '8609'),

                                                  ('Tracteurs (à l''exclusion des chariots-tracteurs du no 8709 ):', '8701'),

                                                  ('Véhicules automobiles pour le transport de dix personnes ou plus, chauffeur inclus:', '8702'),

                                                  ('Voitures de tourisme et autres véhicules automobiles principalement conçus pour le transport de personnes (autres que ceux du no 8702 ), y compris les voitures du type «break» et les voitures de course:', '8703'),

                                                  ('Véhicules automobiles pour le transport de marchandises:', '8704'),

                                                  ('Véhicules automobiles à usages spéciaux, autres que ceux principalement conçus pour le transport de personnes ou de marchandises (dépanneuses, camions-grues, voitures de lutte contre l''incendie, camions-bétonnières, voitures balayeuses, voitures épandeuses, voitures-ateliers, voitures radiologiques, par exemple):', '8705'),

                                                  ('Châssis des véhicules automobiles des nos 8701  à 8705 , équipés de leur moteur:', '8706'),

                                                  ('Carrosseries des véhicules automobiles des nos 8701  à 8705 , y compris les cabines:', '8707'),

                                                  ('Parties et accessoires des véhicules automobiles des nos 8701  à 8705 :', '8708'),

                                                  ('Chariots automobiles non munis d''un dispositif de levage, des types utilisés dans les usines, les entrepôts, les ports ou les aéroports pour le transport des marchandises sur de courtes distances; chariots-tracteurs des types utilisés dans les gares; leurs parties:', '8709'),

                                                  ('Chars et automobiles blindées de combat, armés ou non; leurs parties', '8710'),

                                                  ('Motocycles (y compris les cyclomoteurs) et cycles équipés d''un moteur auxiliaire, avec ou sans side-cars; side-cars:', '8711'),

                                                  ('Bicyclettes et autres cycles (y compris les triporteurs), sans moteur:', '8712'),

                                                  ('Fauteuils roulants et autres véhicules pour invalides, même avec moteur ou autre mécanisme de propulsion:', '8713'),

                                                  ('Parties et accessoires des véhicules des nos 8711  à 8713 :', '8714'),

                                                  ('Landaus, poussettes et voitures similaires pour le transport des enfants, et leurs parties:', '8715'),

                                                  ('Remorques et semi-remorques pour tous véhicules; autres véhicules non automobiles; leurs parties:', '8716'),

                                                  ('Ballons et dirigeables; planeurs, ailes volantes et autres véhicules aériens, non conçus pour la propulsion à moteur:', '8801'),

                                                  ('Autres véhicules aériens (hélicoptères, avions, par exemple), à l’exception des véhicules aériens sans pilote du n° 8806 ; véhicules spatiaux (y compris les satellites) et leurs véhicules lanceurs et véhicules sous-orbitaux:', '8802'),

                                                  ('Parachutes (y compris les parachutes dirigeables et les parapentes) et rotochutes; leurs parties et accessoires', '8804'),

                                                  ('Appareils et dispositifs pour le lancement de véhicules aériens; appareils et dispositifs pour l''appontage de véhicules aériens et appareils et dispositifs similaires; appareils au sol d''entraînement au vol; leurs parties:', '8805'),

                                                  ('Véhicules aériens sans pilote:', '8806'),

                                                  ('Parties des appareils nos 8801 , 8802  ou 8806 :', '8807'),

                                                  ('Paquebots, bateaux de croisières, transbordeurs, cargos, péniches et bateaux similaires pour le transport de personnes ou de marchandises:', '8901'),

                                                  ('Bateaux de pêche; navires-usines et autres bateaux pour le traitement ou la mise en conserve des produits de la pêche:', '8902'),

                                                  ('Yachts et autres bateaux et embarcations de plaisance ou de sport; bateaux à rames et canoës:', '8903'),

                                                  ('Remorqueurs et bateaux-pousseurs:', '8904'),

                                                  ('Bateaux-phares, bateaux-pompes, bateaux-dragueurs, pontons-grues et autres bateaux pour lesquels la navigation n''est qu''accessoire par rapport à la fonction principale; docks flottants; plates-formes de forage ou d''exploitation, flottantes ou submersibles:', '8905'),

                                                  ('Autres bateaux, y compris les navires de guerre et les bateaux de sauvetage autres qu''à rames:', '8906'),

                                                  ('Autres engins flottants (radeaux, réservoirs, caissons, coffres d''amarrage, bouées et balises, par exemple):', '8907'),

                                                  ('Bateaux et autres engins flottants à dépecer (31)', '8908'),

                                                  ('Fibres optiques et faisceaux de fibres optiques; câbles de fibres optiques autres que ceux du no 8544 ; matières polarisantes en feuilles ou en plaques; lentilles (y compris les verres de contact), prismes, miroirs et autres éléments d''optique en toutes matières, non montés, autres que ceux en verre non travaillé optiquement:', '9001'),

                                                  ('Lentilles, prismes, miroirs et autres éléments d''optique en toutes matières, montés, pour instruments ou appareils, autres que ceux en verre non travaillé optiquement:', '9002'),

                                                  ('Montures de lunettes ou d''articles similaires, et leurs parties:', '9003'),

                                                  ('Lunettes (correctrices, protectrices ou autres) et articles similaires:', '9004'),

                                                  ('Jumelles, longues-vues, lunettes astronomiques, télescopes optiques, et leurs bâtis; autres instruments d''astronomie et leurs bâtis, à l''exclusion des appareils de radio-astronomie:', '9005'),

                                                  ('Appareils photographiques; appareils et dispositifs, y compris les lampes et tubes, pour la production de la lumière-éclair en photographie, à l''exclusion des lampes et tubes à décharge du no 8539 :', '9006'),

                                                  ('Caméras et projecteurs cinématographiques, même incorporant des appareils d''enregistrement ou de reproduction du son:', '9007'),

                                                  ('Projecteurs d''images fixes; appareils photographiques d''agrandissement ou de réduction:', '9008'),

                                                  ('Appareils et matériel pour laboratoires photographiques ou cinématographiques, non dénommés ni compris ailleurs dans le présent chapitre; négatoscopes; écrans pour projections:', '9010'),

                                                  ('Microscopes optiques, y compris les microscopes pour la photomicrographie, la cinéphotomicrographie ou la microprojection:', '9011'),

                                                  ('Microscopes autres qu''optiques; diffractographes:', '9012'),

                                                  ('Lasers, autres que les diodes laser; autres appareils et instruments d’optique, non dénommés ni compris ailleurs dans le présent chapitre:', '9013'),

                                                  ('Boussoles, y compris les compas de navigation; autres instruments et appareils de navigation:', '9014'),

                                                  ('Instruments et appareils de géodésie, de topographie, d''arpentage, de nivellement, de photogrammétrie, d''hydrographie, d''océanographie, d''hydrologie, de météorologie ou de géophysique, à l''exclusion des boussoles; télémètres:', '9015'),

                                                  ('Balances sensibles à un poids de 5 cg ou moins, avec ou sans poids:', '9016'),

                                                  ('Instruments de dessin, de traçage ou de calcul (machines à dessiner, pantographes, rapporteurs, étuis de mathématiques, règles et cercles à calcul, par exemple); instruments de mesure de longueurs, pour emploi à la main (mètres, micromètres, pieds à coulisse et calibres, par exemple), non dénommés ni compris ailleurs dans le présent chapitre:', '9017'),

                                                  ('Instruments et appareils pour la médecine, la chirurgie, l''art dentaire ou l''art vétérinaire, y compris les appareils de scintigraphie et autres appareils électromédicaux ainsi que les appareils pour tests visuels:', '9018'),

                                                  ('Appareils de mécanothérapie; appareils de massage; appareils de psychotechnie; appareils d''ozonothérapie, d''oxygénothérapie, d''aérosolthérapie, appareils respiratoires de réanimation et autres appareils de thérapie respiratoire:', '9019'),

                                                  ('Autres appareils respiratoires et masques à gaz, à l''exclusion des masques de protection dépourvus de mécanisme et d''élément filtrant amovible:', '9020'),

                                                  ('Articles et appareils d''orthopédie, y compris les ceintures et bandages médico-chirurgicaux et les béquilles; attelles, gouttières et autres articles et appareils pour fractures; articles et appareils de prothèse; appareils pour faciliter l''audition aux sourds et autres appareils à tenir à la main, à porter sur la personne ou à implanter dans l''organisme, afin de compenser une déficience ou une infirmité:', '9021'),

                                                  ('Appareils à rayons X et appareils utilisant les radiations alpha, bêta gamma ou d’autres radiations ionisantes, même à usage médical, chirurgical, dentaire ou vétérinaire, y compris les appareils de radiophotographie ou de radiothérapie, les tubes à rayons X et autres dispositifs générateurs de rayons X, les générateurs de tension, les pupitres de commande, les écrans, les tables, fauteuils et supports similaires d''examen ou de traitement:', '9022'),

                                                  ('Instruments, appareils et modèles conçus pour la démonstration (dans l''enseignement ou les expositions, par exemple), non susceptibles d''autres emplois:', '9023'),

                                                  ('Machines et appareils d''essais de dureté, de traction, de compression, d''élasticité ou d''autres propriétés mécaniques des matériaux (métaux, bois, textiles, papier, matières plastiques, par exemple):', '9024'),

                                                  ('Densimètres, aréomètres, pèse-liquides et instruments flottants similaires, thermomètres, pyromètres, baromètres, hygromètres et psychromètres, enregistreurs ou non, même combinés entre eux:', '9025'),

                                                  ('Instruments et appareils pour la mesure ou le contrôle du débit, du niveau, de la pression ou d''autres caractéristiques variables des liquides ou des gaz (débitmètres, indicateurs de niveau, manomètres, compteurs de chaleur, par exemple), à l''exclusion des instruments et appareils des nos 9014 , 9015 , 9028  ou 9032 :', '9026'),

                                                  ('Instruments et appareils pour analyses physiques ou chimiques (polarimètres, réfractomètres, spectromètres, analyseurs de gaz ou de fumées, par exemple); instruments et appareils pour essais de viscosité, de porosité, de dilatation, de tension superficielle ou similaires ou pour mesures calorimétriques, acoustiques ou photométriques (y compris les indicateurs de temps de pose); microtomes:', '9027'),

                                                  ('Compteurs de gaz, de liquides ou d''électricité, y compris les compteurs pour leur étalonnage:', '9028'),

                                                  ('Autres compteurs (compteurs de tours, compteurs de production, taximètres, totalisateurs de chemin parcouru, podomètres, par exemple); indicateurs de vitesse et tachymètres, autres que ceux des nos 9014  ou 9015 ; stroboscopes:', '9029'),

                                                  ('Oscilloscopes, analyseurs de spectre et autres instruments et appareils pour la mesure ou le contrôle de grandeurs électriques; instruments et appareils pour la mesure ou la détection des radiations alpha, bêta, gamma, X, cosmiques ou autres radiations ionisantes:', '9030'),

                                                  ('Instruments, appareils et machines de mesure ou de contrôle, non dénommés ni compris ailleurs dans le présent chapitre; projecteurs de profils:', '9031'),

                                                  ('Instruments et appareils pour la régulation ou le contrôle automatiques:', '9032'),

                                                  ('Parties et accessoires non dénommés ni compris ailleurs dans le présent chapitre, pour machines, appareils, instruments ou articles du chapitre 90:', '9033'),

                                                  ('Montres-bracelets, montres de poche et montres similaires (y compris les compteurs de temps des mêmes types), avec boîte en métaux précieux ou en plaqués ou doublés de métaux précieux:', '9101'),

                                                  ('Montres-bracelets, montres de poche et montres similaires (y compris les compteurs de temps des mêmes types), autres que celles du no 9101 :', '9102'),

                                                  ('Réveils et pendulettes, à mouvement de montre:', '9103'),

                                                  ('Montres de tableaux de bord et montres similaires, pour automobiles, véhicules aériens, bateaux ou autres véhicules', '9104'),

                                                  ('Réveils, pendules, horloges et appareils d''horlogerie similaires, à mouvement autre que de montre:', '9105'),

                                                  ('Appareils de contrôle du temps et compteurs de temps, à mouvement d''horlogerie ou à moteur synchrone (horloges de pointage, horodateurs, horocompteurs, par exemple):', '9106'),

                                                  ('Interrupteurs horaires et autres appareils permettant de déclencher un mécanisme à temps donné, munis d''un mouvement d''horlogerie ou d''un moteur synchrone', '9107'),

                                                  ('Mouvements de montres, complets et assemblés:', '9108'),

                                                  ('Mouvements d''horlogerie, complets et assemblés, autres que de montres:', '9109'),

                                                  ('Mouvements d''horlogerie complets, non assemblés ou partiellement assemblés (chablons); mouvements d''horlogerie incomplets, assemblés; ébauches de mouvements d''horlogerie:', '9110'),

                                                  ('Boîtes de montres des nos 9101  ou 9102  et leurs parties:', '9111'),

                                                  ('Cages et cabinets d''appareils d''horlogerie et leurs parties:', '9112'),

                                                  ('Bracelets de montres et leurs parties:', '9113'),

                                                  ('Autres fournitures d''horlogerie:', '9114'),

                                                  ('Pianos, même automatiques; clavecins et autres instruments à cordes à clavier:', '9201'),

                                                  ('Autres instruments de musique à cordes (guitares, violons, harpes, par exemple):', '9202'),

                                                  ('Instruments de musique à vent (orgues à tuyaux et à clavier, accordéons, clarinettes, trompettes, cornemuses, par exemple), autres que les orchestrions et les orgues de Barbarie:', '9205'),

                                                  ('Instruments de musique à percussion (tambours, caisses, xylophones, cymbales, castagnettes, maracas, par exemple)', '9206'),

                                                  ('Instruments de musique dont le son est produit ou doit être amplifié par des moyens électriques (orgues, guitares, accordéons, par exemple):', '9207'),

                                                  ('Boîtes à musique, orchestrions, orgues de Barbarie, oiseaux chanteurs, scies musicales et autres instruments de musique non repris dans une autre position du présent chapitre; appeaux de tous types, sifflets, cornes d''appel et autres instruments d''appel ou de signalisation à bouche:', '9208'),

                                                  ('Parties (mécanismes de boîtes à musique, par exemple) et accessoires (cartes, disques et rouleaux pour appareils à jouer mécaniquement, par exemple) d''instruments de musique; métronomes et diapasons de tous types:', '9209'),

                                                  ('Armes de guerre, autres que les revolvers, pistolets et armes blanches du no9307 :', '9301'),

                                                  ('Revolvers et pistolets, autres que ceux des nos 9303  ou 9304', '9302'),

                                                  ('Autres armes à feu et engins similaires utilisant la déflagration de la poudre (fusils et carabines de chasse, armes à feu ne pouvant être chargées que par le canon, pistolets lance-fusées et autres engins conçus uniquement pour lancer des fusées de signalisation, pistolets et revolvers pour le tir à blanc, pistolets d''abattage à cheville, canons lance-amarres, par exemple):', '9303'),

                                                  ('Autres armes (fusils, carabines et pistolets à ressort, à air comprimé ou à gaz, matraques, par exemple), à l''exclusion de celles du no 9307', '9304'),

                                                  ('Parties et accessoires des articles des nos 9301  à 9304 :', '9305'),

                                                  ('Bombes, grenades, torpilles, mines, missiles, cartouches et autres munitions et projectiles, et leurs parties, y compris les chevrotines, plombs de chasse et bourres pour cartouches:', '9306'),

                                                  ('Sabres, épées, baïonnettes, lances et autres armes blanches, leurs parties et leurs fourreaux', '9307'),

                                                  ('Sièges (à l''exclusion de ceux du no 9402 ), même transformables en lits, et leurs parties:', '9401'),

                                                  ('Mobilier pour la médecine, la chirurgie, l''art dentaire ou l''art vétérinaire (tables d''opérations, tables d''examen, lits à mécanisme pour usages cliniques, fauteuils de dentistes, par exemple); fauteuils pour salons de coiffure et fauteuils similaires, avec dispositif à la fois d''orientation et d''élévation; parties de ces articles:', '9402'),

                                                  ('Autres meubles et leurs parties:', '9403'),

                                                  ('Sommiers; articles de literie et articles similaires (matelas, couvre-pieds, édredons, coussins, poufs, oreillers, par exemple), comportant des ressorts ou bien rembourrés ou garnis intérieurement de toutes matières, y compris ceux en caoutchouc alvéolaire ou en matières plastiques alvéolaires, recouverts ou non:', '9404'),

                                                  ('Luminaires et appareils d''éclairage (y compris les projecteurs) et leurs parties, non dénommés ni compris ailleurs; lampes-réclames, enseignes lumineuses, plaques indicatrices lumineuses et articles similaires, possédant une source d''éclairage fixée à demeure, et leurs parties non dénommées ni comprises ailleurs:', '9405'),

                                                  ('Constructions préfabriquées:', '9406'),

                                                  ('Tricycles, trottinettes, autos à pédales et jouets à roues similaires; landaus et poussettes pour poupées; poupées; autres jouets; modèles réduits et modèles similaires pour le divertissement, animés ou non; puzzles de tout genre:', '9503'),

                                                  ('Consoles et machines de jeux vidéo, jeux de société, y compris les jeux à moteur ou à mouvement, les billards, les tables spéciales pour jeux de casino, les jeux de quilles automatiques (bowlings, par exemple), les jeux fonctionnant par l’introduction d’une pièce de monnaie, d’un billet de banque, d’une carte bancaire, d’un jeton ou par tout autre moyen de paiement:', '9504'),

                                                  ('Articles pour fêtes, carnaval ou autres divertissements, y compris les articles de magie et articles-surprises:', '9505'),

                                                  ('Articles et matériel pour la culture physique, la gymnastique, l''athlétisme, les autres sports (y compris le tennis de table) ou les jeux de plein air, non dénommés ni compris ailleurs dans le présent chapitre; piscines et pataugeoires:', '9506'),

                                                  ('Cannes à pêche, hameçons et autres articles pour la pêche à la ligne; épuisettes pour tous usages; leurres (autres que ceux des nos 9208  ou 9705 ) et articles de chasse similaires:', '9507'),

                                                  ('Cirques ambulants et ménageries ambulantes; manèges pour parcs de loisirs et attractions de parcs aquatiques; attractions foraines, y compris les stands de tir; théâtres ambulants:', '9508'),

                                                  ('Ivoire, os, écaille de tortue, corne, bois d''animaux, corail, nacre et autres matières animales à tailler, travaillés, et ouvrages en ces matières (y compris les ouvrages obtenus par moulage):', '9601'),

                                                  ('Matières végétales ou minérales à tailler, travaillées, et ouvrages en ces matières; ouvrages moulés ou taillés en cire, en paraffine, en stéarine, en gommes ou résines naturelles, en pâtes à modeler, et autres ouvrages moulés ou taillés, non dénommés ni compris ailleurs; gélatine non durcie travaillée, autre que celle du no 3503 , et ouvrages en gélatine non durcie', '9602'),

                                                  ('Balais et brosses, même constituant des parties de machines, d''appareils ou de véhicules, balais mécaniques pour emploi à la main, autres qu''à moteur, pinceaux et plumeaux; têtes préparées pour articles de brosserie; tampons et rouleaux à peindre; raclettes en caoutchouc ou en matières souples analogues:', '9603'),

                                                  ('Tamis et cribles, à main', '9604'),

                                                  ('Assortiments de voyage pour la toilette des personnes, la couture ou le nettoyage des chaussures ou des vêtements', '9605'),

                                                  ('Boutons et boutons-pression; formes pour boutons et autres parties de boutons ou de boutons-pression; ébauches de boutons:', '9606'),

                                                  ('Fermetures à glissière et leurs parties:', '9607'),

                                                  ('Stylos et crayons à bille; stylos et marqueurs à mèche feutre ou à autres pointes poreuses; stylos à plume et autres stylos; stylets pour duplicateurs; porte-mine; porte-plume, porte-crayon et articles similaires; parties (y compris les capuchons et les agrafes) de ces articles, à l''exclusion de celles du no 9609 :', '9608'),

                                                  ('Crayons (autres que les crayons du no 9608 ), mines, pastels, fusains, craies à écrire ou à dessiner et craies de tailleurs:', '9609'),

                                                  ('Ardoises et tableaux pour l''écriture ou le dessin, même encadrés', '9610'),

                                                  ('Dateurs, cachets, numéroteurs, timbres et articles similaires (y compris les appareils pour l''impression d''étiquettes), à main; composteurs et imprimeries comportant des composteurs, à main', '9611'),

                                                  ('Rubans encreurs pour machines à écrire et rubans encreurs similaires, encrés ou autrement préparés en vue de laisser des empreintes, même montés sur bobines ou en cartouches; tampons encreurs même imprégnés, avec ou sans boîte:', '9612'),

                                                  ('Briquets et allumeurs (à l''exclusion des allumeurs du no 3603 ), même mécaniques ou électriques, et leurs parties autres que les pierres et les mèches:', '9613'),

                                                  ('Pipes (y compris les têtes de pipes), fume-cigare et fume-cigarette, et leurs parties:', '9614'),

                                                  ('Peignes à coiffer, peignes de coiffure, barrettes et articles similaires; épingles à cheveux; pince-guiches, ondulateurs, bigoudis et articles similaires pour la coiffure, autres que ceux du no 8516 , et leurs parties:', '9615'),

                                                  ('Vaporisateurs de toilette, leurs montures et têtes de montures; houppes et houppettes à poudre ou pour l''application d''autres cosmétiques ou produits de toilette:', '9616'),

                                                  ('Bouteilles isolantes et autres récipients isothermiques montés, dont l''isolation est assurée par le vide, ainsi que leurs parties (à l''exclusion des ampoules en verre)', '9617'),

                                                  ('Mannequins et articles similaires; automates et scènes animées pour étalages', '9618'),

                                                  ('Serviettes et tampons hygiéniques, couches, langes et articles similaires, en toutes matières:', '9619'),

                                                  ('Monopodes, bipieds, trépieds et articles similaires:', '9620'),

                                                  ('Tableaux, peintures et dessins, faits entièrement à la main, à l''exclusion des dessins du no 4906  et des articles manufacturés décorés à la main; collages, mosaïques et tableautins similaires:', '9701'),

                                                  ('Gravures, estampes et lithographies originales:', '9702'),

                                                  ('Productions originales de l''art statuaire ou de la sculpture, en toutes matières:', '9703'),

                                                  ('Timbres-poste, timbres fiscaux, marques postales, enveloppes premier jour, entiers postaux et analogues, oblitérés, ou bien non oblitérés, autres que les articles du no 4907', '9704'),

                                                  ('Collections et pièces de collection présentant un intérêt archéologique, ethnographique, historique, zoologique, botanique, minéralogique, anatomique, paléontologique ou numismatique:', '9705'),

                                                  ('Objets d''antiquité ayant plus de cent ans d''âge:', '9706');
