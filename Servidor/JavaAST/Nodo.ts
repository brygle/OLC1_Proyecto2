class Nodo{

    private titulo:string;
    private hijos:Nodo[];

    constructor(t:string){
        this.titulo = t;
        this.hijos = [];
    }

    agregar(hijo:Nodo){
        this.hijos.push(hijo);
    }

    getTitulo():string {
        return this.titulo;
    }

    getHijos():Nodo[] {
        return this.hijos;
    }
}
export{Nodo};