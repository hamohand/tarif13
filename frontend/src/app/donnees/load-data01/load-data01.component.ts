import {Component, OnInit} from '@angular/core';
import {Article} from "../../../assets/objets/articles";
import {DataLoaderService} from "../../data-loader.service";
import {NgForOf} from "@angular/common";

@Component({
  selector: 'app-load-data01',
  standalone: true,
  imports: [
    NgForOf
  ],
  //templateUrl: './load-data01.component.html',
  template: `
   <h2>Liste des articles</h2>
   <ul>
     <li *ngFor="let article of articles">
       {{ article.designation }} - {{ article.code }}
     </li>
   </ul>
 `,

  styleUrl: './load-data01.component.css'
})
export class LoadData01Component implements OnInit{
  articles: Article[] = [];

  constructor(private dataLoader: DataLoaderService) { }

  ngOnInit(): void {
// Le chemin doit correspondre à l'emplacement de votre fichier
    const csvFilePath = 'assets/donnees/jeu01.csv';

    this.dataLoader.getData<Article>(csvFilePath).subscribe(data => {
      this.articles = data;
      console.log('Objets JavaScript chargés depuis le CSV :', this.articles);
    });

  }

}
