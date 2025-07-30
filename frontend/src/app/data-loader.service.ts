import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {catchError, Observable, of} from 'rxjs';
import { map } from 'rxjs/operators';
import * as Papa from 'papaparse';

// Optionnel : Définir une interface pour typer vos objets
/*export interface Produit {
  id: number;
  nom: string;
  prix: number;
  description: string;
}*/

@Injectable({
  providedIn: 'root'
})
export class DataLoaderService {

  constructor(private http: HttpClient) { }

  /**
   * Charge et parse un fichier CSV pour le convertir en un tableau d'objets.
   * @param filePath Le chemin vers le fichier CSV dans le dossier 'assets'.
   * @returns Un Observable contenant le tableau d'objets.
   */
  public getData<T>(filePath: string): Observable<T[]> {
    return this.http.get(filePath, { responseType: 'text' }).pipe(
        map(csvText => {
          const parsedData = Papa.parse(csvText, {
            header: true,
            skipEmptyLines: true,
            dynamicTyping: true,
          });

          // Vérifier si PapaParse a rencontré des erreurs non bloquantes
          if (parsedData.errors && parsedData.errors.length > 0) {
            console.error('Erreurs de parsing CSV:', parsedData.errors);
            // Lancer une erreur pour qu'elle soit interceptée par catchError
            throw new Error('Une ou plusieurs erreurs sont survenues lors du parsing du CSV.');
          }

          // Le transtypage reste une assertion de confiance au développeur
          return parsedData.data as T[];
        }),
        catchError(error => {
          // Intercepte les erreurs HTTP (ex: 404) et les erreurs de parsing lancées manuellement
          console.error(`Erreur lors du chargement ou du parsing du fichier ${filePath}:`, error);

          // Retourne un Observable avec un tableau vide comme valeur par défaut sécurisée
          // pour que le consommateur de l'API n'ait pas à gérer un cas d'erreur.
          return of([]);
        })
    );
  }

}

