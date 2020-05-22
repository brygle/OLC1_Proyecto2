class Variable{

    private nombre:string;
    private tipo:string;
    private clasePadre:string;
    private funcionPadre:string;

    constructor(nombre:string, tipo:string, clasePadre:string, funcionPadre:string){
        this.nombre = nombre;
        this.tipo = tipo;
        this.clasePadre = clasePadre;
        this.funcionPadre = funcionPadre;
    }

    getNombre():string {
        return this.nombre;
    }

    getTipo():string {
        return this.tipo;
    }

    getClase():string {
        return this.clasePadre;
    }

    getFuncion():string {
        return this.funcionPadre;
    }
}
export{Variable};