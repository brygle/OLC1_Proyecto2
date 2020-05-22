"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Funcion = /** @class */ (function () {
    function Funcion(nombre, tipo, parametros, clasePadre) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.parametros = parametros;
        this.firma = nombre + "-" + tipo + "-" + parametros;
        this.clasePadre = clasePadre;
        this.listaVariables = [];
        this.listaParametros = [];
    }
    Funcion.prototype.setVariables = function (lista) {
        for (var i = 0; i < lista.length; i++) {
            this.listaVariables.push(lista[i]);
        }
    };
    Funcion.prototype.setParametros = function (lista) {
        for (var i = 0; i < lista.length; i++) {
            var parametro = lista[i];
            this.firma += parametro.getTipo() + ",";
            this.listaParametros.push(lista[i]);
        }
    };
    Funcion.prototype.getNombre = function () {
        return this.nombre;
    };
    Funcion.prototype.getTipo = function () {
        return this.tipo;
    };
    Funcion.prototype.getParametros = function () {
        return this.parametros;
    };
    Funcion.prototype.getFirma = function () {
        return this.firma;
    };
    Funcion.prototype.getClase = function () {
        return this.clasePadre;
    };
    return Funcion;
}());
exports.Funcion = Funcion;
