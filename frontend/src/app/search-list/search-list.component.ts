import {Component, OnInit} from '@angular/core';
import {Article, articles} from "../../assets/objets/articles";
import {NgForOf} from "@angular/common";
import {SearchService} from "../services/search.service";
import {ReactiveFormsModule} from "@angular/forms";
import {catchError, finalize, Observable, of, from, concatMap, toArray} from "rxjs";
import {DataLoaderService} from "../data-loader.service";

@Component({
  selector: 'app-search-list',
  standalone: true,
  imports: [
    NgForOf,
    ReactiveFormsModule
  ],
  templateUrl: './search-list.component.html',
  styleUrl: './search-list.component.css'
})
export class SearchListComponent implements OnInit{
  //lesarticles: Article[] = articles;
  lesarticles: Article[] = [];
  searchTerm: string = '';
  searchResults: string | null = null;
  isLoading: boolean = false;
  error: string | null = null;

  constructor(private searchService: SearchService,
              private dataLoader: DataLoaderService) {}

  // ngOnInit est un bon endroit pour charger les données initiales
  ngOnInit(): void {
    this.chargerDonneesInitiales();
  }

  // Exemple de méthode pour charger les données
  chargerDonneesInitiales(): void {
    this.isLoading = true;
    const csvFilePath = 'assets/donnees/jeu01.csv'; // fichier CSV

    // 2. Appelez la méthode du service
    this.dataLoader.getData<Article>(csvFilePath)
        // 3. Souscrivez à l'Observable
        .subscribe({
          next: (donnees) => {
            // 4. Affectez les données reçues à la variable du composant
            this.lesarticles = donnees;
            this.isLoading = false;
            console.log('Les articles ont été chargés :', this.lesarticles);
          },
          error: (erreur) => {
            console.error('Erreur lors du chargement des articles :', erreur);
            this.isLoading = false;
          }
        });
  }

  /**
   * Lance la recherche des codes pour tous les articles de la liste de manière séquentielle.
   */
  search(): void {
    // S'il n'y a pas d'articles, on ne fait rien.
    if (!this.lesarticles?.length) {
      return;
    }

    this.isLoading = true;
    this.error = null;

    // On transforme le tableau d'articles en un flux qui les émet un par un
    from(this.lesarticles).pipe(
        // concatMap exécute les recherches séquentiellement (une à la fois)
        concatMap(article => this.createArticleSearchObservable(article)),
        // toArray collecte tous les résultats dans un seul tableau à la fin
        toArray(),
        // finalize s'exécute que l'opération réussisse ou échoue
        finalize(() => this.isLoading = false)
    ).subscribe({
      next: (results) => {
        // On met à jour le code de chaque article avec les résultats.
        results.forEach((code, index) => {
          this.lesarticles[index].code = code;
        });
        console.log("Toutes les recherches sont terminées.", this.lesarticles);
      },
      error: (err) => {
        // Ce bloc est une sécurité, même si les erreurs individuelles sont déjà traitées.
        this.error = 'Une erreur inattendue est survenue lors du traitement des recherches.';
        console.error('Erreur inattendue dans la chaîne de traitement séquentiel:', err);
      }
    });
  }

  /**
   * Crée un Observable pour la recherche du code d'un article.
   * Gère les erreurs individuelles et les articles sans titre.
   * @param article L'article pour lequel créer la requête de recherche.
   * @returns Un Observable qui émettra le code trouvé ou le code existant.
   */
  private createArticleSearchObservable(article: Article): Observable<string> {
    if (!article.designation) {
      // S'il n'y a pas de titre, on retourne un Observable avec le code existant.
      return of(article.code);
    }

    return this.searchService.searchCodes(article.designation).pipe(
        catchError(err => {
          console.error(`Erreur lors de la recherche pour "${article.designation}":`, err);
          // On définit un message d'erreur général seulement s'il n'y en a pas déjà un.
          if (!this.error) {
            this.error = 'Une erreur est survenue lors de la recherche. Veuillez réessayer.';
          }
          // Pour les requêtes échouées, on retourne le code original pour ne pas bloquer l'interface.
          return of(article.code);
        })
    );
  }
}

/**
 * ### Le Problème : Exécution Parallèle avec `forkJoin`
 * Le comportement que vous décrivez est typique d'un serveur qui reçoit trop de requêtes simultanées. Voici ce qui se passe :
 * 1. **est Parallèle`forkJoin`** : L'opérateur attend que vous lui donniez une liste d'Observables (vos requêtes de recherche). Dès qu'il s'abonne, il lance **toutes les requêtes en même temps**, en parallèle. `forkJoin`
 * 2. **Surcharge du Serveur** : Si vous avez 3, 5 ou 10 articles, votre application envoie 3, 5 ou 10 requêtes HTTP au serveur backend _exactement au même moment_. De nombreux serveurs ou API sont configurés avec des mécanismes de protection (appelés "rate limiting" ou limitation de débit) pour éviter d'être surchargés. Lorsqu'ils détectent un afflux soudain de requêtes depuis la même source, ils peuvent en rejeter certaines, ce qui provoque les erreurs que vous observez.
 *
 * Une recherche unique fonctionne bien car elle n'active pas ces protections. C'est le volume soudain de requêtes qui pose problème.
 * ### La Solution : Exécution Séquentielle avec `concatMap`
 * Pour résoudre ce problème, nous devons cesser d'envoyer toutes les requêtes en même temps. À la place, nous allons les exécuter les unes après les autres : envoyer une requête, attendre sa réponse, puis envoyer la suivante. C'est ce qu'on appelle une exécution **séquentielle**.
 * L'opérateur RxJS parfait pour cela est `concatMap`.
 * Voici comment nous pouvons modifier votre code pour utiliser cette stratégie :
 * 1. Nous utiliserons `from(this.lesarticles)` pour créer un flux (Observable) qui émettra chaque article de votre liste, un par un.
 * 2. Nous utiliserons l'opérateur sur ce flux. `pipe`
 * 3. À l'intérieur de , nous utiliserons `concatMap`. Pour chaque article reçu, `concatMap` appellera et attendra que cette requête soit terminée avant de passer à l'article suivant. `pipe``createArticleSearchObservable`
 * 4. Enfin, nous utiliserons l'opérateur `toArray` pour collecter tous les résultats individuels dans un seul tableau, afin d'obtenir un comportement final similaire à . `forkJoin`
 */