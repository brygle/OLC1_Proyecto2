"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var express = require("express");
var cors = require("cors");
var bodyParser = require("body-parser");
var gramatica = require("./AnalizadorJava/GramaticaJava");
var Errores_1 = require("./JavaAST/Errores");
var Variable_1 = require("./JavaAST/Variable");
var Clase_1 = require("./JavaAST/Clase");
var Funcion_1 = require("./JavaAST/Funcion");
var app = express();
app.use(bodyParser.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
var listaClases;
var listaVariables;
var listaFunciones;
var clasePadre;
var funcionPadre;
app.post('/Calcular/', function (req, res) {
    Errores_1.Errores.clear();
    var izq = req.body.izquierdo;
    var der = req.body.derecho;
    console.log(izq);
    var resizq = parser(izq);
    var resder = parser(der);
    var lista = [];
    lista.push(resizq);
    lista.push(resder);
    listaClases = [];
    listaVariables = [];
    listaFunciones = [];
    clasePadre = "";
    funcionPadre = "";
    recorrer(resizq);
    lista.push(listaClases);
    listaClases = [];
    listaVariables = [];
    listaFunciones = [];
    clasePadre = "";
    funcionPadre = "";
    recorrer(resder);
    lista.push(listaClases);
    lista.push(Errores_1.Errores.geterror());
    console.log(JSON.stringify(Errores_1.Errores));
    //Errores.clear();
    //res.send(resultado.toString());
    res.send(JSON.stringify(lista));
});
/*---------------------------------------------------------------*/
var server = app.listen(8080, function () {
    console.log('Servidor escuchando en puerto 8080...');
});
/*---------------------------------------------------------------*/
function parser(texto) {
    try {
        var lista = [];
        var respuesta = gramatica.parse(texto);
        return respuesta;
    }
    catch (e) {
        return "Error en compilacion de Entrada: " + e.toString();
    }
}
function imprimir(raiz) {
    console.log(raiz.getTitulo());
    for (var i = 0; i < raiz.getHijos().length; i++) {
        imprimir(raiz.getHijos()[i]);
    }
}
function recorrer(raiz) {
    console.log(raiz.getTitulo());
    if (raiz.getTitulo() == "DECLARACION") {
        var raizHijos = raiz.getHijos();
        var tipo = raizHijos[0].getHijos()[0].getTitulo();
        var listaVar = raizHijos[1];
        for (var i = 0; i < listaVar.getHijos().length; i++) {
            var iden = listaVar.getHijos()[i];
            var varia = iden.getHijos()[0].getTitulo();
            var variable = new Variable_1.Variable(varia, tipo, clasePadre, funcionPadre);
            listaVariables.push(variable);
        }
    }
    else if (raiz.getTitulo() == "METODO") {
        var raizHijos = raiz.getHijos();
        if (raizHijos.length == 3) {
            var tipo = raizHijos[0].getHijos()[0].getTitulo();
            var varia = raizHijos[1].getHijos()[0].getTitulo();
            var met = new Funcion_1.Funcion(varia, tipo, "", clasePadre);
            funcionPadre = varia;
            recorrer(raizHijos[2]);
            funcionPadre = "";
            met.setVariables(listaVariables);
            listaVariables = [];
            listaFunciones.push(met);
        }
        else {
            var tipo = raizHijos[0].getHijos()[0].getTitulo();
            var varia = raizHijos[1].getHijos()[0].getTitulo();
            var met = new Funcion_1.Funcion(varia, tipo, "", clasePadre);
            //set variables
            funcionPadre = varia;
            recorrer(raizHijos[3]);
            funcionPadre = "";
            //set parametros y firma
            var listaParametros;
            listaParametros = [];
            for (var i = 0; i < raizHijos[2].getHijos().length; i++) {
                var parametro = raizHijos[2].getHijos()[i];
                var tipoparametro = parametro.getHijos()[0].getHijos()[0].getTitulo();
                var nombreparametro = parametro.getHijos()[1].getHijos()[0].getTitulo();
                var paramVariable = new Variable_1.Variable(nombreparametro, tipoparametro, "", "");
                listaParametros.push(paramVariable);
            }
            met.setParametros(listaParametros);
            listaFunciones.push(met);
        }
    }
    else if (raiz.getTitulo() == "FUNCION") {
        var raizHijos = raiz.getHijos();
        if (raizHijos.length == 3) {
            var tipo = raizHijos[0].getHijos()[0].getTitulo();
            var varia = raizHijos[1].getHijos()[0].getTitulo();
            var met = new Funcion_1.Funcion(varia, tipo, "", clasePadre);
            funcionPadre = varia;
            recorrer(raizHijos[2]);
            funcionPadre = "";
            met.setVariables(listaVariables);
            listaVariables = [];
            listaFunciones.push(met);
        }
        else {
            var tipo = raizHijos[0].getHijos()[0].getTitulo();
            var varia = raizHijos[1].getHijos()[0].getTitulo();
            var met = new Funcion_1.Funcion(varia, tipo, "", clasePadre);
            //set variables
            funcionPadre = varia;
            recorrer(raizHijos[3]);
            funcionPadre = "";
            //set parametros y firma
            var listaParametros;
            listaParametros = [];
            for (var i = 0; i < raizHijos[2].getHijos().length; i++) {
                var parametro = raizHijos[2].getHijos()[i];
                var tipoparametro = parametro.getHijos()[0].getHijos()[0].getTitulo();
                var nombreparametro = parametro.getHijos()[1].getHijos()[0].getTitulo();
                var paramVariable = new Variable_1.Variable(nombreparametro, tipoparametro, "", "");
                listaParametros.push(paramVariable);
            }
            met.setParametros(listaParametros);
            listaFunciones.push(met);
        }
    }
    else if (raiz.getTitulo() == "CLASE") {
        var raizHijos = raiz.getHijos();
        var nombre = raizHijos[0].getHijos()[0].getTitulo();
        clasePadre = nombre;
        recorrer(raizHijos[1]);
        clasePadre = "";
        var clase = new Clase_1.Clase(nombre);
        clase.setFunciones(listaFunciones);
        listaClases.push(clase);
        listaFunciones = [];
    }
    else {
        for (var i = 0; i < raiz.getHijos().length; i++) {
            recorrer(raiz.getHijos()[i]);
        }
    }
}
