import { Variable } from "./Variable";

class Funcion{

    private nombre:string;
    private tipo:string;
    private parametros:string;
    private firma:string;
    private clasePadre:string;
    private listaVariables:Variable[];
    private listaParametros:Variable[];

    constructor(nombre:string, tipo:string, parametros:string, clasePadre:string){
        this.nombre = nombre;
        this.tipo = tipo;
        this.parametros = parametros;
        this.firma = nombre + "-" + tipo + "-" + parametros;
        this.clasePadre = clasePadre;
        this.listaVariables=[];
        this.listaParametros =[];
    }

    setVariables(lista:Variable[]):void {
        for(var i = 0; i < lista.length ; i++){
            this.listaVariables.push(lista[i]);
        }
    }

    setParametros(lista:Variable[]):void {
        for(var i = 0; i < lista.length ; i++){
            var parametro = lista[i];
            this.firma += parametro.getTipo() + ","
            this.listaParametros.push(lista[i]);
        }
    }

    getNombre():string {
        return this.nombre;
    }

    getTipo():string {
        return this.tipo;
    }

    getParametros():string {
        return this.parametros;
    }

    getFirma():string {
        return this.firma;
    }

    getClase():string {
        return this.clasePadre;
    }

}
export{Funcion};