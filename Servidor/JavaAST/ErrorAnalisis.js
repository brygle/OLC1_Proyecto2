"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var ErrorAnalisis = /** @class */ (function () {
    function ErrorAnalisis(descripcion, tipo, linea, columna) {
        this.descripcion = descripcion;
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
    }
    ErrorAnalisis.prototype.getDescripcion = function () {
        return this.descripcion;
    };
    ErrorAnalisis.prototype.getTipo = function () {
        return this.tipo;
    };
    ErrorAnalisis.prototype.getLinea = function () {
        return this.linea;
    };
    ErrorAnalisis.prototype.getColumna = function () {
        return this.columna;
    };
    return ErrorAnalisis;
}());
exports.ErrorAnalisis = ErrorAnalisis;
