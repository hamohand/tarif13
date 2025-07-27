import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SearchService } from '../services/search.service';

@Component({
  selector: 'app-search',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="search-container">
      <!-- -->
      <div class="search-form">
        <input 
          type="text" 
          [(ngModel)]="searchTerm" 
          placeholder="Entrez un terme ou une expression de recherche (accepte plusieurs langues)" 
          class="search-input"
          (keydown.enter)="search()"
        />
        <button 
          (click)="search()" 
          class="search-button"
          [disabled]="isLoading || !searchTerm"
        >
          {{ isLoading ? 'Recherche en cours...' : 'Rechercher' }}
        </button>
      </div>

      <div *ngIf="isLoading" class="loading">
        Recherche en cours...
      </div>

      <div *ngIf="error" class="error">
        {{ error }}
      </div>

      <div *ngIf="searchResults && !isLoading" class="results">
        <h3>Résultats de la recherche</h3>
        <pre>{{ searchResults }}</pre>
      </div>
    </div>
  `,
  styles: [`
    .search-container {
      padding: 20px;
      max-width: 800px;
      margin: 0 auto;
    }

    h2 {
      text-align: center;
      margin-bottom: 25px;
      color: #2c3e80;
    }

    .search-form {
      display: flex;
      margin-bottom: 25px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      border-radius: 8px;
      overflow: hidden;
    }

    .search-input {
      flex: 1;
      padding: 14px 16px;
      font-size: 16px;
      border: none;
      outline: none;
      transition: all 0.3s;
    }

    .search-input:focus {
      box-shadow: inset 0 0 0 2px #3498db;
    }

    .search-button {
      padding: 14px 24px;
      font-size: 16px;
      background-color: #3498db;
      color: white;
      border: none;
      font-weight: 500;
      letter-spacing: 0.5px;
      transition: all 0.3s ease;
    }

    .search-button:hover:not(:disabled) {
      background-color: #2980b9;
    }

    .search-button:disabled {
      background-color: #bdc3c7;
      cursor: not-allowed;
      transform: none;
    }

    .loading {
      margin: 25px 0;
      font-style: italic;
      text-align: center;
      color: #7f8c8d;
    }

    .error {
      margin: 25px 0;
      color: #e74c3c;
      background-color: #fadbd8;
      padding: 12px;
      border-radius: 6px;
      text-align: center;
    }

    .results {
      margin-top: 25px;
      padding: 25px;
      background-color: #f9f9f9;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      border-left: 4px solid #3498db;
    }

    .results h3 {
      margin-bottom: 15px;
      color: #3498db;
    }

    pre {
      white-space: pre-wrap;
      font-family: 'Courier New', Courier, monospace;
      line-height: 1.6;
      background-color: #fff;
      padding: 15px;
      border-radius: 6px;
      border: 1px solid #e9ecef;
    }
  `]
})
export class SearchComponent {
  searchTerm: string = '';
  searchResults: string | null = null;
  isLoading: boolean = false;
  error: string | null = null;

  constructor(private searchService: SearchService) {}

  search(): void {
    if (!this.searchTerm) {
      this.error = 'Veuillez entrer un terme de recherche';
      return;
    }

    this.isLoading = true;
    this.error = null;
    this.searchResults = null;

    this.searchService.searchCodes(this.searchTerm)
      .subscribe({
        next: (results) => {
          this.searchResults = results;
          console.log('search resultats:', results);
          this.isLoading = false;
        },
        error: (err) => {
          console.error('Error searching chapters:', err);
          this.error = 'Une erreur est survenue lors de la recherche. Veuillez réessayer.';
          this.isLoading = false;
        }
      });
  }
}
