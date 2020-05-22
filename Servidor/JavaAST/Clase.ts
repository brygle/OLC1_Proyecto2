import { Variable } from "./Variable";
import { Funcion } from "./Funcion";

class Clase{

    private nombre:string;
    private listaFunciones:Funcion[];

    constructor(t:string){
        this.nombre = t;
        this.listaFunciones = [];
    }

    setFunciones(lista:Funcion[]):void {
        for(var i = 0; i < lista.length ; i++){
            this.listaFunciones.push(lista[i]);
        }
    }

    getNombre():string {
        return this.nombre;
    }

    getFunciones():Funcion[] {
        return this.listaFunciones;
    }
}
export{Clase};