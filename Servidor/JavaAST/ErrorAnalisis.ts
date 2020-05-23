class ErrorAnalisis{

    private descripcion:string;
    private tipo:string;
    private linea:string;
    private columna:string;

    constructor(descripcion:string, tipo:string, linea:string, columna:string){
        this.descripcion = descripcion;
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
    }

    getDescripcion():string {
        return this.descripcion;
    }

    getTipo():string {
        return this.tipo;
    }

    getLinea():string {
        return this.linea;
    }

    getColumna():string {
        return this.columna;
    }
}
export{ErrorAnalisis};