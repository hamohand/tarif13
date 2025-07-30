export class Article {

    designation: string;
    code: string;
    description: string;

    constructor(code: string, titre: string, auteur: string){
        this.designation = titre;
        this.code = code;
        this.description = auteur;
    }
 
 }

export const articles : Article[] =
    [
        {
            designation : "sel",
            code : "1",
            description : "Jonathan Littell",
        },
        {
            designation : "pommes",
            code : "2",
            description : "Amélie Nothomb",
        },
        {
            designation : "voitures diesel",
            code : "3",
            description : "Nothomb",
        }
    ]