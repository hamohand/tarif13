import { Routes } from '@angular/router';
import { SearchComponent } from './search/search.component';
import {ChapitresComponent} from "./chapitres/chapitres.component";
import {SearchListComponent} from "./search-list/search-list.component";

export const routes: Routes = [
    // { path: '', redirectTo: 'search', pathMatch: 'full' },
    // { path: 'search', component: SearchComponent },
    // { path: '**', redirectTo: 'search' }
  // { path: '', redirectTo: 'chapitres', pathMatch: 'full' },
  // { path: 'chapitres', component: ChapitresComponent },
  // { path: '**', redirectTo: 'chapitres' }
    { path: '', redirectTo: 'searchList', pathMatch: 'full' },
    { path: 'searchList', component: SearchListComponent },
    { path: '**', redirectTo: 'searchList' }
];