"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Variable = /** @class */ (function () {
    function Variable(nombre, tipo, clasePadre, funcionPadre) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.clasePadre = clasePadre;
        this.funcionPadre = funcionPadre;
    }
    Variable.prototype.getNombre = function () {
        return this.nombre;
    };
    Variable.prototype.getTipo = function () {
        return this.tipo;
    };
    Variable.prototype.getClase = function () {
        return this.clasePadre;
    };
    Variable.prototype.getFuncion = function () {
        return this.funcionPadre;
    };
    return Variable;
}());
exports.Variable = Variable;
