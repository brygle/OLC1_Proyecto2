
/*------------------------------------------------IMPORTS----------------------------------------------*/
%{
    let CPrimitivo=require('../JavaAST/Expresiones/Primitivo');
    let CAritmetica=require('../JavaAST/Expresiones/Aritmetica');
    let CLExpresion=require('../JavaAST/Expresiones/LExpresion');
    let CErrores=require('../JavaAST/Errores');
    let CNodoError=require('../JavaAST/NodoError');
    let CNodo=require('../JavaAST/Nodo');

    let CClase = require('../JavaAST/Clase');
    let CVariable = require('../JavaAST/Variable');
    let CFuncion = require('../JavaAST/Funcion');

    var listaVariables = [];
    var listaClases = [];
    var listaFunciones = [];

    var variableGlobal ;
    var claseGlobal ;
    var tipoGlobal = "";

    function getClases(){
        return listaClases;
    }

%}



/*------------------------------------------------LEXICO------------------------------------------------*/
%lex
%%

/*--------------------------------------EXPRESIONES REGULARES-------------------------------------------------*/
//COMENTARIOS
["/"]["/"][^\r\n]*[\n|\r|\r\n|\n\r]?        %{     %}
"/*"[^/]~"*/"|"/*""/"+"*/"                  %{     %}

//TIPOS
"int"			 	return 'rint'
"double"			return 'rdouble'
"boolean"  			return 'rboolean'
"char"			 	return 'rchar'
"String"			return 'rstring'

//OPERADORES ARITMETICOS
"++"     return 'incremento'
"--"     return 'decremento'
"*"     return 'multiplicacion'
"/"     return 'division'
"-"     return 'resta'
"+"     return 'suma'
"^"     return 'pow'
"%"     return 'modulo'

//OPERADORES RELACIONALES
"<="     return 'menorigual'
">="     return 'mayorigual'
"!="     return 'distinto'
"=="     return 'comparacion'
"<"     return 'menor'
">"     return 'mayor'


//OPERADORES LOGICOS
"||"     return 'or'
"&&"     return 'and'
"!"     return 'not'

//SIMBOLOS CUALESQUIERA
","     return 'coma'
"."     return 'punto'
";"     return 'puntocoma'
":"     return 'dospuntos'
"{"     return 'llavea'
"}"     return 'llavec'
"("     return 'para'
")"     return 'parc'
"="     return 'igual'

//RESERVADAS
"class"    	return 'tclass'
"import"    return 'timport'
"if"    	return 'tif'
"else"   	return 'telse'
"switch"    return 'tswitch'
"case"     	return 'tcase'
"break"     return 'tbreak'
"default"   return 'tdefault'
"for"     	return 'tfor'
"while"     return 'twhile'
"do"     	return 'tdo'
"continue"  return 'tcontinue'
"return"    return 'treturn'
"void"     	return 'tvoid'
"System"    return 'tsystem'
"out"     	return 'tout'
"println"   return 'tprintln'
"print"     return 'tprint'

//LEXEMAS
"true"                                           return 'rtrue'
"false"                                          return 'rfalse'
[0-9]+"."[0-9]+                                  %{  return 'doble';  %}
[0-9]+                                           %{  return 'entero';  %}
(\'[.]\')                                              %{  return 'caracter';  %}
[\"][^\"]*[\"]                                   %{  return 'cadena';  %}
([a-zñA-ZÑ]|"_")([a-zñA-ZÑ]|"_"|[0-9])*          %{  return 'identificador';  %} 

[ \t\r\n\f]                                      %{ /*se ignoran*/ %}

<<EOF>>     %{  return 'EOF';   %}

.           CErrores.Errores.add(new CNodoError.NodoError("Lexico","No se esperaba el caracter: "+yytext,yylineno))

/lex

/*--------------------------------------------------SINTACTICO-----------------------------------------------*/

/*-----ASOCIACION Y PRECEDENCIA-----*/
%left or 
%left and
%left comparacion distinto
%left menorigual mayorigual menor mayor
%left suma resta
%left multiplicacion division modulo
%left pow
%right not UMENOS UMAS
%right incremento decremento    
%left para parc


%start S
%% 

S:L_INS EOF { 
                var raiz = new CNodo.Nodo("RAIZ");
                raiz.agregar($1);
                $$ = raiz;
                return $$;
            };

/*---------------------------EXPRESIONES------------------------------------------*/

E:   E suma E               {  
                                var n = new CNodo.Nodo("ARITMETICA");
                                var n2 = new CNodo.Nodo("SUMA");
                                n.agregar(n2);

                                var n3 = new CNodo.Nodo("EXPRESION");
                                n3.agregar($1);
                                var n4 = new CNodo.Nodo("EXPRESION");
                                n4.agregar($3);

                                n2.agregar(n3);
                                n2.agregar(n4);

                                $$ = n;
                            }
    |E resta E              {  
                                var n = new CNodo.Nodo("ARITMETICA");
                                var n2 = new CNodo.Nodo("RESTA");
                                n.agregar(n2);

                                var n3 = new CNodo.Nodo("EXPRESION");
                                n3.agregar($1);
                                var n4 = new CNodo.Nodo("EXPRESION");
                                n4.agregar($3);

                                n2.agregar(n3);
                                n2.agregar(n4);

                                $$ = n;
                            }
    |E multiplicacion E     {    
                                var n = new CNodo.Nodo("ARITMETICA");
                                var n2 = new CNodo.Nodo("MULTIPLICACION");
                                n.agregar(n2);

                                var n3 = new CNodo.Nodo("EXPRESION");
                                n3.agregar($1);
                                var n4 = new CNodo.Nodo("EXPRESION");
                                n4.agregar($3);

                                n2.agregar(n3);
                                n2.agregar(n4);

                                $$ = n;
                            }
    |E division E           {  
                                var n = new CNodo.Nodo("ARITMETICA");
                                var n2 = new CNodo.Nodo("DIVISION");
                                n.agregar(n2);

                                var n3 = new CNodo.Nodo("EXPRESION");
                                n3.agregar($1);
                                var n4 = new CNodo.Nodo("EXPRESION");
                                n4.agregar($3);

                                n2.agregar(n3);
                                n2.agregar(n4);

                                $$ = n;
                            }
    |E modulo E             {  
                                var n = new CNodo.Nodo("ARITMETICA");
                                var n2 = new CNodo.Nodo("MODULO");
                                n.agregar(n2);

                                var n3 = new CNodo.Nodo("EXPRESION");
                                n3.agregar($1);
                                var n4 = new CNodo.Nodo("EXPRESION");
                                n4.agregar($3);

                                n2.agregar(n3);
                                n2.agregar(n4);

                                $$ = n;
                            }
    |E pow E                {  
                                var n = new CNodo.Nodo("ARITMETICA");
                                var n2 = new CNodo.Nodo("POTENCIA");
                                n.agregar(n2);

                                var n3 = new CNodo.Nodo("EXPRESION");
                                n3.agregar($1);
                                var n4 = new CNodo.Nodo("EXPRESION");
                                n4.agregar($3);

                                n2.agregar(n3);
                                n2.agregar(n4);

                                $$ = n;
                            }
    |E mayorigual E              {  
                                    var n = new CNodo.Nodo("RELACIONAL");
                                    var n2 = new CNodo.Nodo("MAYOR O IGUAL");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($1);
                                    var n4 = new CNodo.Nodo("EXPRESION");
                                    n4.agregar($3);

                                    n2.agregar(n3);
                                    n2.agregar(n4);

                                    $$ = n;
                                }
    |E menorigual E              {  
                                    var n = new CNodo.Nodo("RELACIONAL");
                                    var n2 = new CNodo.Nodo("MENOR O IGUAL");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($1);
                                    var n4 = new CNodo.Nodo("EXPRESION");
                                    n4.agregar($3);

                                    n2.agregar(n3);
                                    n2.agregar(n4);

                                    $$ = n;
                                }
    |E distinto E                {  
                                    var n = new CNodo.Nodo("RELACIONAL");
                                    var n2 = new CNodo.Nodo("DISTINTO");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($1);
                                    var n4 = new CNodo.Nodo("EXPRESION");
                                    n4.agregar($3);

                                    n2.agregar(n3);
                                    n2.agregar(n4);

                                    $$ = n;
                                }
    |E comparacion E             {  
                                    var n = new CNodo.Nodo("RELACIONAL");
                                    var n2 = new CNodo.Nodo("IGUALES");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($1);
                                    var n4 = new CNodo.Nodo("EXPRESION");
                                    n4.agregar($3);

                                    n2.agregar(n3);
                                    n2.agregar(n4);

                                    $$ = n;
                                }
    |E menor E                   {  
                                    var n = new CNodo.Nodo("RELACIONAL");
                                    var n2 = new CNodo.Nodo("MENOR");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($1);
                                    var n4 = new CNodo.Nodo("EXPRESION");
                                    n4.agregar($3);

                                    n2.agregar(n3);
                                    n2.agregar(n4);

                                    $$ = n;
                                }
    |E mayor E                   {  
                                    var n = new CNodo.Nodo("RELACIONAL");
                                    var n2 = new CNodo.Nodo("MAYOR");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($1);
                                    var n4 = new CNodo.Nodo("EXPRESION");
                                    n4.agregar($3);

                                    n2.agregar(n3);
                                    n2.agregar(n4);

                                    $$ = n;
                                }
    |E and E                    {  
                                    var n = new CNodo.Nodo("LOGICA");
                                    var n2 = new CNodo.Nodo("AND");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($1);
                                    var n4 = new CNodo.Nodo("EXPRESION");
                                    n4.agregar($3);

                                    n2.agregar(n3);
                                    n2.agregar(n4);

                                    $$ = n;
                                }
    |E or E                     {  
                                    var n = new CNodo.Nodo("LOGICA");
                                    var n2 = new CNodo.Nodo("OR");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($1);
                                    var n4 = new CNodo.Nodo("EXPRESION");
                                    n4.agregar($3);

                                    n2.agregar(n3);
                                    n2.agregar(n4);

                                    $$ = n;
                                }
    |not E                      {  
                                    var n = new CNodo.Nodo("LOGICA");
                                    var n2 = new CNodo.Nodo("NOT");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($2);

                                    n2.agregar(n3);

                                    $$ = n;
                                }
    |para E parc                {  $$=$2; }
    |resta E   %prec UMENOS     {  
                                    var n = new CNodo.Nodo("ARITMETICA");
                                    var n2 = new CNodo.Nodo("MENOS UNARIO");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($2);

                                    n2.agregar(n3);

                                    $$ = n;
                                }
    |suma E   %prec UMAS        {  
                                    var n = new CNodo.Nodo("ARITMETICA");
                                    var n2 = new CNodo.Nodo("MAS UNARIO");
                                    n.agregar(n2);

                                    var n3 = new CNodo.Nodo("EXPRESION");
                                    n3.agregar($2);

                                    n2.agregar(n3);

                                    $$ = n;
                                }
    |entero                                        {  
                                                        var n = new CNodo.Nodo("Expresion");
                                                        var n2 = new CNodo.Nodo("Primitivo");
                                                        n.agregar(n2);
                                                        $$ = n ;  }
    |doble                                         {  
                                                        var n = new CNodo.Nodo("Expresion");
                                                        var n2 = new CNodo.Nodo("Primitivo");
                                                        n.agregar(n2);
                                                        $$ = n ;  }
    |caracter                                      {  
                                                        var n = new CNodo.Nodo("Expresion");
                                                        var n2 = new CNodo.Nodo("Primitivo");
                                                        n.agregar(n2);
                                                        $$ = n ;  }
    |cadena                                        {  
                                                        var n = new CNodo.Nodo("Expresion");
                                                        var n2 = new CNodo.Nodo("Primitivo");
                                                        n.agregar(n2);
                                                        $$ = n ;  }
    |rtrue                                         {  
                                                        var n = new CNodo.Nodo("Expresion");
                                                        var n2 = new CNodo.Nodo("Primitivo");
                                                        n.agregar(n2);
                                                        $$ = n ;  }
    |rfalse                                        {  
                                                        var n = new CNodo.Nodo("Expresion");
                                                        var n2 = new CNodo.Nodo("Primitivo");
                                                        n.agregar(n2);
                                                        $$ = n ;  }
    |identificador                                 {  
                                                        var n = new CNodo.Nodo("EXPRESION");
                                                        var n2 = new CNodo.Nodo("IDENTIFICADOR");
                                                        var varia = new CNodo.Nodo($1 + "");
                                                        n2.agregar(varia);
                                                        n.agregar(n2);
                                                        $$ = n ;  }
    |identificador incremento                      {  
                                                        var n = new CNodo.Nodo("EXPRESION");
                                                        var n2 = new CNodo.Nodo("IDENTIFICADOR");
                                                        var n3 = new CNodo.Nodo("INCREMENTO");
                                                        var varia = new CNodo.Nodo($1 + "");
                                                        n2.agregar(varia);
                                                        n.agregar(n2);
                                                        n.agregar(n3);
                                                        $$ = n ;  }
    |identificador decremento                      {  
                                                        var n = new CNodo.Nodo("EXPRESION");
                                                        var n2 = new CNodo.Nodo("IDENTIFICADOR");
                                                        var varia = new CNodo.Nodo($1 + "");
                                                        n2.agregar(varia);
                                                        var n3 = new CNodo.Nodo("DECREMENTO");
                                                        n.agregar(n2);
                                                        n.agregar(n3);
                                                        $$ = n ;  }
    |identificador para parc                       {  
                                                        var n = new CNodo.Nodo("EXPRESION");
                                                        var n2 = new CNodo.Nodo("LLAMADA");
                                                        var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                        var varia = new CNodo.Nodo($1 + "");
                                                        iden.agregar(varia);
                                                        n2.agregar(iden);
                                                        n.agregar(n2);
                                                        $$ = n ;  }
    |identificador para L_ARGUMENTOS parc          {  
                                                        var n = new CNodo.Nodo("EXPRESION");
                                                        var n2 = new CNodo.Nodo("LLAMADA");
                                                        n.agregar(n2);
                                                        var n3 = new CNodo.Nodo("IDENTIFICADOR");
                                                        var n4 = new CNodo.Nodo("LISTA_ARGUMENTOS");
                                                        var varia = new CNodo.Nodo($1 + "");
                                                        n3.agregar(varia);
                                                        n2.agregar(n3);
                                                        n2.agregar(n4);
                                                        $$ = n ;  };


/*---------------------------DECLARACION Y ASIGNACION------------------------------------------*/
T: rint                 {  
                            var n = new CNodo.Nodo("TIPO");
                            var n2 = new CNodo.Nodo("INT");
                            n.agregar(n2);
                            tipo = "int";
                            $$ = n;
                        }
    | rdouble           {  
                            var n = new CNodo.Nodo("TIPO");
                            var n2 = new CNodo.Nodo("DOUBLE");
                            n.agregar(n2);
                            tipo = "double";
                            $$ = n;
                        }
    | rstring           {  
                            var n = new CNodo.Nodo("TIPO");
                            var n2 = new CNodo.Nodo("STRING");
                            n.agregar(n2);
                            tipo = "string";
                            $$ = n;
                        }
    | rboolean          {  
                            var n = new CNodo.Nodo("TIPO");
                            var n2 = new CNodo.Nodo("BOOLEAN");
                            n.agregar(n2);
                            tipo = "boolean";
                            $$ = n;
                        }
    | rchar             {  
                            var n = new CNodo.Nodo("TIPO");
                            var n2 = new CNodo.Nodo("CHAR");
                            n.agregar(n2);
                            tipo = "char";
                            $$ = n;
                        };

DECLARACION: T LISTA_ID igual E     { 
                                        var decla = new CNodo.Nodo("DECLARACION");
                                        decla.agregar($1);
                                        decla.agregar($2);
                                        decla.agregar($4);

                                        /*var listaIdentificadores = $2;
                                        for(var i = 0; i< listaIdentificadores.getHijos().length; i++){
                                            var nombreVar = listaIdentificadores.getHijos()[i].getHijos[0].getTitulo();
                                            var varia = new CVariable.Variable(nombreVar, tipoGlobal, "", "");
                                            listaVariables.push(varia);
                                        }   */                                   

                                        $$ = decla;
                                    }   
            | T LISTA_ID            { 
                                        var decla = new CNodo.Nodo("DECLARACION");
                                        decla.agregar($1);
                                        decla.agregar($2);

                                        var listaIdentificadores = $2;
                                        for(var i = 0; i< listaIdentificadores.getHijos().length; i++){
                                            var nombreVar = listaIdentificadores.getHijos()[i].getHijos[0].getTitulo();
                                            var varia = new CVariable.Variable(nombreVar, tipoGlobal, "", "");
                                            listaVariables.push(varia);
                                        } 


                                        $$ = decla;
                                    };

LISTA_ID: LISTA_ID coma identificador   { 
                                            var lista = $1;
                                            var iden = new CNodo.Nodo("IDENTIFICADOR");
                                            var varia = new CNodo.Nodo($3 + "");
                                            iden.agregar(varia);
                                            lista.agregar(iden);
                                            $$ = lista;
                                        }
        | identificador                 { 
                                            var lista = new CNodo.Nodo("LISTA VARIABLES");
                                            var iden = new CNodo.Nodo("IDENTIFICADOR");
                                            var varia = new CNodo.Nodo($1 + "");
                                            iden.agregar(varia);
                                            lista.agregar(iden);
                                            $$ = lista; 
                                        };

ASIGNACION: identificador igual E   { 
                                        var asigna = new CNodo.Nodo("ASIGNACION");
                                        
                                        var iden = new CNodo.Nodo("IDENTIFICADOR");
                                        var varia = new CNodo.Nodo($1 + "");
                                        iden.agregar(varia);
                                        var expr = new CNodo.Nodo("EXPRESION");
                                        expr.agregar($3);
                                        asigna.agregar(iden);
                                        asigna.agregar(expr);

                                        $$ = asigna;
                                    };


/*---------------------------CLASE E IMPORT------------------------------------------*/
SENTENCIA_IMPORT: timport E     { 
                                    var imp = new CNodo.Nodo("IMPORT");
                                    var expr = new CNodo.Nodo("EXPRESION");
                                    expr.agregar($2);
                                    imp.agregar(expr);
                                    $$ = imp;
                                };

SENTENCIA_CLASE: tclass identificador BLOQUE        {
                                                        var cla = new CNodo.Nodo("CLASE");
                                                        var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                        var varia = new CNodo.Nodo($2 + "");
                                                        iden.agregar(varia);
                                                        cla.agregar(iden);
                                                        cla.agregar($3);

                                                        /*var nombre = $2 + "";
                                                        var tmp = new CClase.Clase(nombre);
                                                        tmp.setFunciones(listaFunciones);
                                                        listaFunciones = [];
                                                        listaClases.push(tmp);*/
                                                        $$ = cla;
                                                    };

/*---------------------------FUNCIONES------------------------------------------*/

SENTENCIA_METODO: tvoid identificador para parc BLOQUE                  { 
                                                                var meto = new CNodo.Nodo("METODO");

                                                                var tipo = new CNodo.Nodo("TIPO");
                                                                var t = new CNodo.Nodo("VOID");
                                                                tipo.agregar(t);


                                                                var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                                var varia = new CNodo.Nodo($2 + "");
                                                                iden.agregar(varia);

                                                                meto.agregar(tipo);
                                                                meto.agregar(iden);
                                                                meto.agregar($5);

                                                                /*var tip = "void";
                                                                var nombre = $2 + "";
                                                                var funci = new CFuncion.Funcion(nombre, tip, "", "");
                                                                funci.setVariables(listaVariables);
                                                                listaVariables = [];
                                                                listaFunciones.push(funci);
                                                                */

                                                                $$ = meto;
                                                            }
                | tvoid identificador para L_PARAMETROS parc BLOQUE     { 
                                                                var meto = new CNodo.Nodo("METODO");

                                                                var tipo = new CNodo.Nodo("TIPO");
                                                                var t = new CNodo.Nodo("VOID");
                                                                tipo.agregar(t);

                                                                var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                                var varia = new CNodo.Nodo($2 + "");
                                                                iden.agregar(varia);

                                                                meto.agregar(tipo);
                                                                meto.agregar(iden);
                                                                meto.agregar($4);
                                                                meto.agregar($6);

                                                                var tip = "void";
                                                                var nombre = $2 + "";

                                                                var listaParametros = [];
                                                                var nodoListaParametros = $4;
                                                                var ParametrosNodo = nodoListaParametros.getHijos();
                                                                for(var i =0 ; i < ParametrosNodo.length ; i++){
                                                                    var parametroNodo = ParametrosNodo[i];

                                                                    var tipoNodo = parametroNodo.getHijos()[0];
                                                                    var tipoParametro = tipoNodo.getHijos()[0].getTitulo();


                                                                    var idenNodo = parametroNodo.getHijos()[1];
                                                                    var nombreParametro = idenNodo.getHijos()[0].getTitulo();

                                                                    var tmp = new CVariable.Variable(nombreParametro, tipoParametro, "", "");
                                                                    listaParametros.push(tmp);
                                                                }   


                                                                var funci = new CFuncion.Funcion(nombre, tip, "", "");
                                                                funci.setVariables(listaVariables);
                                                                funci.setParametros(listaParametros);
                                                                listaVariables = [];
                                                                listaFunciones.push(funci);
                                                                


                                                                $$ = meto;
                                                             };

SENTENCIA_FUNCION: T identificador para parc BLOQUE                { 
                                                                var funci = new CNodo.Nodo("FUNCION");
                                                                var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                                var varia = new CNodo.Nodo($2 + "");
                                                                iden.agregar(varia);
                                                                funci.agregar($1);
                                                                funci.agregar(iden);
                                                                funci.agregar($5);
                                                                $$ = funci;
                                                        }
                 | T identificador para L_PARAMETROS parc BLOQUE     {
                                                                var funci = new CNodo.Nodo("FUNCION");
                                                                var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                                var varia = new CNodo.Nodo($2 + "");
                                                                iden.agregar(varia);
                                                                funci.agregar($1);
                                                                funci.agregar(iden);
                                                                funci.agregar($4);
                                                                funci.agregar($6);
                                                                $$ = funci;
                                                          };

L_PARAMETROS: L_PARAMETROS coma PARAMETRO       { 
                                                    var lista = $1;
                                                    lista.agregar($3);
                                                    $$ = lista;
                                                }
            | PARAMETRO                         { 
                                                    var lista = new CNodo.Nodo("LISTA PARAMETROS");
                                                    lista.agregar($1);
                                                    $$ = lista; 
                                                };

PARAMETRO: T identificador                      { 
                                                    var param = new CNodo.Nodo("PARAMETRO");
                                                    param.agregar($1);

                                                    var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                    var varia = new CNodo.Nodo($2 + "");
                                                    iden.agregar(varia);

                                                    param.agregar(iden);

                                                    $$ = param;
                                                };

L_ARGUMENTOS: L_ARGUMENTOS coma E       {   
                                            var lista = $1;
                                            var expr = new CNodo.Nodo("EXPRESION");
                                            expr.agregar($3);
                                            lista.agregar(expr);
                                            $$ = lista;
                                        }
                | E                     {  
                                            var lista = new CNodo.Nodo("LISTA ARGUMENTOS");
                                            var expr = new CNodo.Nodo("EXPRESION");
                                            expr.agregar($1);
                                            lista.agregar(expr);
                                            $$ = lista; 
                                        };

SENTENCIA_LLAMADA: identificador para parc          { 
                                                        var llamada = new CNodo.Nodo("LLAMADA");
                                                        var iden =  new CNodo.Nodo("IDENTIFICADOR");
                                                        var varia = new CNodo.Nodo($1 + "");
                                                        iden.agregar(varia);
                                                        llamada.agregar(iden);
                                                        $$ = llamada;
                                                    }
                 | identificador para L_ARGUMENTOS parc { 
                                                            var llamada = new CNodo.Nodo("LLAMADA");
                                                            var iden =  new CNodo.Nodo("IDENTIFICADOR");
                                                            var varia = new CNodo.Nodo($1 + "");
                                                            iden.agregar(varia);
                                                            llamada.agregar(iden);
                                                            llamada.agregar($3);
                                                            $$ = llamada; 
                                                        };

SENTENCIA_RETURN: treturn E     {
                                    var ret = new CNodo.Nodo("RETURN");
                                    var expr = new CNodo.Nodo("EXPRESION");
                                    expr.agregar($2);
                                    ret.agregar(expr);
                                    $$ = ret;
                                }
                | treturn       { 
                                    var ret = new CNodo.Nodo("RETURN");
                                    $$ = ret;
                                };

IMPRIMIR: tsystem punto tout punto tprint para E parc       {
                                                                var imp = new CNodo.Nodo("IMPRIMIR");
                                                                var expr = new CNodo.Nodo("EXPRESION");
                                                                expr.agregar($7);
                                                                imp.agregar(expr);
                                                                $$ = imp;
                                                            }
        | tsystem punto tout punto tprintln para E parc      { 
                                                                var imp = new CNodo.Nodo("IMPRIMIR CON SALTO");
                                                                var expr = new CNodo.Nodo("EXPRESION");
                                                                expr.agregar($7);
                                                                imp.agregar(expr);
                                                                $$ = imp;
                                                            };

/*---------------------------SENTENCIAS DE CONTROL------------------------------------------*/

SENTENCIA_IF: L_CONDICIONES telse BLOQUE        { 
                                                    var senif = $1;
                                                    var sif = new CNodo.Nodo("ELSE");

                                                    sif.agregar($3);

                                                    senif.agregar(sif);
                                                    $$= senif;
                                                }
            | L_CONDICIONES                     { 
                                                    $$ = $1;
                                                };

L_CONDICIONES: L_CONDICIONES telse tif para E parc BLOQUE   { 
                                                                var senif = $1;
                                                                var sif = new CNodo.Nodo("ELSE IF");

                                                                var cond = new CNodo.Nodo("CONDICION");  
                                                                var expr = new CNodo.Nodo("EXPRESION");
                                                                expr.agregar($5);
                                                                cond.agregar(expr);

                                                                sif.agregar(cond);
                                                                sif.agregar($7);

                                                                senif.agregar(sif);
                                                                $$= senif;
                                                            }
            |  tif para E parc BLOQUE                       { 
                                                                var senif = new CNodo.Nodo("SENTENCIA IF");
                                                                var sif = new CNodo.Nodo("IF");

                                                                var cond = new CNodo.Nodo("CONDICION");  
                                                                var expr = new CNodo.Nodo("EXPRESION");
                                                                expr.agregar($3);
                                                                cond.agregar(expr);

                                                                sif.agregar(cond);
                                                                sif.agregar($5);

                                                                senif.agregar(sif);
                                                                $$= senif;

                                                            };

SENTENCIA_SWITCH: tswitch para E parc llavea L_CASOS llavec { 
                                                                var swi = new CNodo.Nodo("SWITCH");

                                                                var cond = new CNodo.Nodo("PARAMETRO");
                                                                var expr = new CNodo.Nodo("EXPRESION");
                                                                expr.agregar($3);
                                                                cond.agregar(expr);

                                                                swi.agregar(cond);
                                                                swi.agregar($6);

                                                                $$ = swi;
                                                            };

L_CASOS: L_CASOS CASO       { 
                                var lista = $1;
                                lista.agregar($2);
                                $$ = lista;
                            }
        |CASO               { 
                                var lista = new CNodo.Nodo("LISTA CASOS");
                                lista.agregar($1);
                                $$ = lista;
                            };

CASO: tcase E dospuntos L_INS       { 
                                        var caso = new CNodo.Nodo("CASE");

                                        var cond = new CNodo.Nodo("CONDICION");  
                                        var expr = new CNodo.Nodo("EXPRESION");
                                        expr.agregar($2);
                                        cond.agregar(expr);

                                        caso.agregar(cond);
                                        caso.agregar($4);
                                        $$= caso; 
                                    }
    | tdefault dospuntos L_INS      { 
                                        var defa = new CNodo.Nodo("DEFAULT");
                                        defa.agregar($3);
                                        $$= defa;
                                    };

/*---------------------------SENTENCIAS DE REPETICION------------------------------------------*/

SENTENCIA_WHILE: twhile para E parc BLOQUE          { 
                                                        var whil = new CNodo.Nodo("WHILE");

                                                        var cond = new CNodo.Nodo("CONDICION");  
                                                        var expr = new CNodo.Nodo("EXPRESION");
                                                        expr.agregar($3);
                                                        cond.agregar(expr);

                                                        whil.agregar(cond);
                                                        whil.agregar($5);

                                                        $$ = whil;
                                                        
                                                    };

SENTENCIA_DOWHILE: tdo BLOQUE twhile para E parc    { 
                                                        var whil = new CNodo.Nodo("DO WHILE");

                                                        var cond = new CNodo.Nodo("CONDICION");  
                                                        var expr = new CNodo.Nodo("EXPRESION");
                                                        expr.agregar($5);
                                                        cond.agregar(expr);

                                                        whil.agregar($2);
                                                        whil.agregar(cond);

                                                        $$ = whil;
                                                    };

SENTENCIA_FOR: tfor para INICIO_FOR puntocoma E puntocoma ACTUALIZAR_FOR parc BLOQUE    { 
                                                                                            var ciclo = new CNodo.Nodo("FOR");

                                                                                            var cond = new CNodo.Nodo("CONDICION");  
                                                                                            var expr = new CNodo.Nodo("EXPRESION");
                                                                                            expr.agregar($5);
                                                                                            cond.agregar(expr);

                                                                                            ciclo.agregar($3);
                                                                                            ciclo.agregar(cond);
                                                                                            ciclo.agregar($7);
                                                                                            ciclo.agregar($9);

                                                                                            $$ = ciclo;
                                                                                        };

INICIO_FOR: DECLARACION     { 
                                var inicio = new CNodo.Nodo("INICIALIZACION");
                                inicio.agregar($1);
                                $$ = inicio;
                            }
        |   ASIGNACION      { 
                                var inicio = new CNodo.Nodo("INICIALIZACION");
                                inicio.agregar($1);
                                $$ = inicio;
                            };

ACTUALIZAR_FOR: ASIGNACION      { 
                                    var actualizacion = new CNodo.Nodo("ACTUALIZACION");
                                    actualizacion.agregar($1);
                                    $$ = actualizacion;
                                }
            |  identificador incremento { 
                                            var actualizacion = new CNodo.Nodo("ACTUALIZACION");
                                            var incre = new CNodo.Nodo("INCREMENTO");
                                            var iden = new CNodo.Nodo("IDENTIFICADOR");
                                            var varia = new CNodo.Nodo($1 + "");
                                            iden.agregar(varia);
                                            incre.agregar(iden);
                                            actualizacion.agregar(incre);
                                            $$ = actualizacion;
                                        }
            |  identificador decremento { 
                                            var actualizacion = new CNodo.Nodo("ACTUALIZACION");
                                            var decre = new CNodo.Nodo("DECREMENTO");
                                            var iden = new CNodo.Nodo("IDENTIFICADOR");
                                            var varia = new CNodo.Nodo($1 + "");
                                            iden.agregar(varia);
                                            decre.agregar(iden);
                                            actualizacion.agregar(decre);
                                            $$ = actualizacion;
                                        };

/*---------------------------   INSTRUCCIONES   ------------------------------------------*/

BLOQUE: llavea llavec           { 
                                    var lista = new CNodo.Nodo("LISTA DE INSTRUCCIONES");
                                    $$ = lista;
                                }
        | llavea L_INS llavec   { 
                                    $$ = $2;
                                };

L_INS: L_INS INS        { 
                            var lista = $1;
                            lista.agregar($2);
                            $$ = lista;
                        }
    | INS               { 
                            var lista = new CNodo.Nodo("LISTA DE INSTRUCCIONES");
                            lista.agregar($1);
                            $$ = lista;
                        };

INS: DECLARACION puntocoma          { 
                                        $$ = $1;
                                    }
    |ASIGNACION puntocoma          { 
                                        $$ = $1;        
                                    }
    |IMPRIMIR puntocoma             { 
                                        $$ = $1;
                                    }
    |tbreak puntocoma               { 
                                        var bre = new CNodo.Nodo("BREAK");
                                        $$ = bre;
                                    }
    |tcontinue puntocoma            { 
                                        var con = new CNodo.Nodo("CONTINUE");
                                        $$ = con;
                                    }
    |SENTENCIA_RETURN puntocoma     { 
                                        $$ = $1;
                                    }
    |SENTENCIA_IMPORT puntocoma     { 
                                        $$ = $1;
                                    }
    |SENTENCIA_CLASE                { 
                                        $$ = $1;
                                    }
    |SENTENCIA_METODO               { 
                                        $$ = $1;
                                    }
    |SENTENCIA_FUNCION              { 
                                        $$ = $1;
                                    }
    |SENTENCIA_LLAMADA puntocoma    { 
                                        $$ = $1;
                                    }
    |identificador incremento puntocoma     { 
                                                var incre = new CNodo.Nodo("INCREMENTO");
                                                var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                var varia = new CNodo.Nodo($1 + "");
                                                iden.agregar(varia);
                                                incre.agregar(iden);
                                                $$ = incre;
                                            }
    |identificador decremento puntocoma     { 
                                                var decre = new CNodo.Nodo("DECREMENTO");
                                                var iden = new CNodo.Nodo("IDENTIFICADOR");
                                                var varia = new CNodo.Nodo($1 + "");
                                                iden.agregar(varia);
                                                decre.agregar(iden);
                                                $$ = decre;
                                            }
    |SENTENCIA_IF                   { 
                                        $$ = $1;
                                    }
    |SENTENCIA_SWITCH               { 
                                        $$ = $1;
                                    }
    |SENTENCIA_WHILE                { 
                                        $$ = $1;
                                    }
    |SENTENCIA_DOWHILE puntocoma             { 
                                        $$ = $1;
                                    }
    |SENTENCIA_FOR                  { 
                                        $$ = $1;
                                    }
    | error                         { 
                                        var er = new CNodo.Nodo("ERROR");
                                        $$ = er;
                                    };

