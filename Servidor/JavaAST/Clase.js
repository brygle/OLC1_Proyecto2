"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Clase = /** @class */ (function () {
    function Clase(t) {
        this.nombre = t;
        this.listaFunciones = [];
    }
    Clase.prototype.setFunciones = function (lista) {
        for (var i = 0; i < lista.length; i++) {
            this.listaFunciones.push(lista[i]);
        }
    };
    Clase.prototype.getNombre = function () {
        return this.nombre;
    };
    Clase.prototype.getFunciones = function () {
        return this.listaFunciones;
    };
    return Clase;
}());
exports.Clase = Clase;
