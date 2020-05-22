function Conn(){

    var left = document.getElementById("izquierdo").value;
    var right = document.getElementById("derecho").value;
    console.log(left);
    console.log(right);

    var url='http://localhost:8080/Calcular/';

    $.post(url,{izquierdo:left, derecho: right},function(data,status){
        if(status.toString()=="success"){
            //alert("El resultado es: "+data.toString());
            var lista = JSON.parse(data);
            //alert("EL SIZE ES " + lista.length);
            //imprimirDatos(lista);
            colocarArbolIzq(lista[0]);
            colocarArbolDer(lista[1]);
            //alert(JSON.stringify(lista[2]));
            //alert(JSON.stringify(lista[3]));
            listaVariables = [];
            listaFunciones = [];
            listaClases = [];
            clasesCopia(lista[2], lista[3]);

            //alert(JSON.stringify(listaVariables));
            //alert(JSON.stringify(listaFunciones));
            //alert(JSON.stringify(listaClases));

            var divclase = document.getElementById('copiaclases');
            divclase.innerHTML = getClasesCopia();
            var divfunciones = document.getElementById('copiafunciones');
            divfunciones.innerHTML = getFuncionesCopia();
            var divvariables = document.getElementById('copiavariables');
            divvariables.innerHTML = getVariablesCopia();

        }else{
            alert("Error estado de conexion:"+status);
        }
    });
}

function imprimirDatos(lista){
    for(var i = 0; i < lista.length; i++){
        imprimir(lista[i]);
    }
}

function imprimir(raiz){
    console.log(raiz.titulo);
    for(var i = 0; i < raiz.hijos.length; i++){
        imprimir(raiz.hijos[i]);
    }
}

function colocarArbolIzq(raiz){
    var cadena = "<ul class='jstree-container-ul jstree-children' role='group' >";
    cadena += genArbol(raiz);
    cadena += "</ul>";

    var divArbol = document.getElementById('html');
    divArbol.innerHTML = cadena ;
}

function colocarArbolDer(raiz){
    var cadena = "<ul class='jstree-container-ul jstree-children' role='group' >";
    cadena += genArbol(raiz);
    cadena += "</ul>";

    var divArbol = document.getElementById('htmlDer');
    divArbol.innerHTML = cadena ;
}

function genArbol(raiz){
    var cadena = "<li role=\"treeitem\" data-jstree='{ \"opened\" : true }' aria-selected='false' aria-level='1' aria-labelledby='jl_1_anchor' aria-expanded='true' class='jstree-node jstree-last jstree-open' id='jl_1'>";
    cadena += "<i class='jstree-icon jstree-ocl' role='presentation'></i>" ;
    cadena += "<a class='jstree-anchor' href='#' tabindex='-1' >";
    cadena += "<i class='jstree-icon jstree-themeicon' role='presentation'></i>";
    cadena += raiz.titulo;
    cadena += "</a>";
    if(raiz.hijos.length>0){
        cadena += "<ul role=\"group\" class=\"jstree-container-ul jstree-children \">";
            for(var i = 0; i < raiz.hijos.length; i++){
                cadena += genArbol(raiz.hijos[i]);
            } 
        cadena += "</ul>";
    }
    cadena += "</li>";
    return cadena;
}
var listaVariables = [];
var listaFunciones = [];
var listaClases = [];

function variablesCopia(a, b){
    for(var i = 0; i< a.listaVariables.length ; i++){
        for(var j = 0; j< b.listaVariables.length; j++){
            if( a.listaVariables[i].tipo == b.listaVariables[j].tipo &&
                a.listaVariables[i].nombre == b.listaVariables[j].nombre &&
                a.listaVariables[i].clasePadre == b.listaVariables[j].clasePadre &&
                a.listaVariables[i].funcionPadre == b.listaVariables[j].funcionPadre ){
                    listaVariables.push(b.listaVariables[j]);
            } else {

            }
        }
    }    
}

function funcionesCopia(a, b){
    var hayCopia = true;
    for(var i = 0; i< a.listaFunciones.length ; i++){
        var bandera  = false;
        for(var j = 0; j< b.listaFunciones.length; j++){
            if( a.listaFunciones[i].firma == b.listaFunciones[j].firma &&
                a.listaFunciones[i].clase == b.listaFunciones[j].clase ){
                    listaFunciones.push(b.listaFunciones[j]);
                    bandera = true;
                    variablesCopia(a.listaFunciones[i], b.listaFunciones[j]);
            } 
        }
        hayCopia = hayCopia && bandera;
    }    
    return hayCopia;
}

function clasesCopia(a, b){
    var hayCopia = true;
    for(var i = 0; i< a.length ; i++){
        var bandera  = false;
        for(var j = 0; j< b.length; j++){
            if( a[i].nombre == b[j].nombre &&
                funcionesCopia(a[i], b[i]) ){
                    listaClases.push(b[j]);
                    bandera = true;
            } 
        }
        hayCopia = hayCopia && bandera;
    }    
    return hayCopia;
}

function getClasesCopia(){
    var cadena = "<h1>CLASES COPIA</h1>"
    cadena += "<table>";

    cadena += "<tr>";
    cadena += "<th>";
    cadena += "No.";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "NOMBRE CLASE";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "No. METODOS/FUNCIONES";
    cadena += "</th>";
    cadena += "</tr>";

    for(var i = 0; i< listaClases.length ; i++){
        cadena += "<tr>";
        
        cadena += "<td>";
        cadena += (i +1);
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaClases[i].nombre;
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaClases[i].listaFunciones.length;
        cadena += "</td>";

        cadena += "</tr>";
    }

    cadena += "</table>";

    return cadena;
}

function getFuncionesCopia(){
    var cadena = "<h1>Funciones COPIA</h1>"
    cadena += "<table>";

    cadena += "<tr>";
    cadena += "<th>";
    cadena += "No.";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "NOMBRE FUNCION";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "TIPO RETORNO";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "NOMBRE CLASE";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "LISTA PARAMETROS";
    cadena += "</th>";
    cadena += "</tr>";

    for(var i = 0; i< listaFunciones.length ; i++){
        cadena += "<tr>";
        
        cadena += "<td>";
        cadena += (i +1);
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaFunciones[i].nombre;
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaFunciones[i].tipo;
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaFunciones[i].clasePadre;
        cadena += "</td>";

        cadena += "<td>";

        cadena += "<table>";
        cadena += "<tr>";

        cadena += "<th>";
        cadena += "TIPO";
        cadena += "</th>";

        cadena += "<th>";
        cadena += "NOMBRE";
        cadena += "</th>";

        cadena += "</tr>";
        for(var j = 0; j < listaFunciones[i].listaParametros.length; j++){
            cadena += "<tr>";
            cadena += "<td>";
            cadena += listaFunciones[i].listaParametros[j].tipo;
            cadena += "</td>";
            cadena += "<td>";
            cadena += listaFunciones[i].listaParametros[j].nombre;
            cadena += "</td>";
            cadena += "</tr>";
        }
        cadena += "</table>";
        cadena += "</td>";

        cadena += "</tr>";
    }

    cadena += "</table>";

    return cadena;
}

function getVariablesCopia(){
    var cadena = "<h1>VARIABLES COPIA</h1>"
    cadena += "<table>";

    cadena += "<tr>";
    cadena += "<th>";
    cadena += "No.";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "TIPO VARIABLE";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "NOMBRE VARIABLE";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "FUNCION";
    cadena += "</th>";

    cadena += "<th>";
    cadena += "CLASE";
    cadena += "</th>";

    cadena += "</tr>";

    for(var i = 0; i< listaVariables.length ; i++){
        cadena += "<tr>";
        
        cadena += "<td>";
        cadena += (i +1);
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaVariables[i].tipo;
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaVariables[i].nombre;
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaVariables[i].funcionPadre;
        cadena += "</td>";

        cadena += "<td>";
        cadena += listaVariables[i].clasePadre;
        cadena += "</td>";

        cadena += "</tr>";
    }

    cadena += "</table>";

    return cadena;
}