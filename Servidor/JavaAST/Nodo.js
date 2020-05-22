"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Nodo = /** @class */ (function () {
    function Nodo(t) {
        this.titulo = t;
        this.hijos = [];
    }
    Nodo.prototype.agregar = function (hijo) {
        this.hijos.push(hijo);
    };
    Nodo.prototype.getTitulo = function () {
        return this.titulo;
    };
    Nodo.prototype.getHijos = function () {
        return this.hijos;
    };
    return Nodo;
}());
exports.Nodo = Nodo;
