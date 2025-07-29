export class Article {

    articleTitle: string;
    code: string;
    description: string;

    constructor(code: string, titre: string, auteur: string){
        this.articleTitle = titre;
        this.code = code;
        this.description = auteur;
    }
 
 }

export const articles : Article[] =
    [
        {
            articleTitle : "sel",
            code : "1",
            description : "Jonathan Littell",
        },
        {
            articleTitle : "pommes",
            code : "2",
            description : "Amélie Nothomb",
        },
        {
            articleTitle : "voitures diesel",
            code : "3",
            description : "Nothomb",
        }
    ]