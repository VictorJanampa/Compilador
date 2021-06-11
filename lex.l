%option noyywrap
%{
	#include "y.tab.h"
	#include<stdio.h>
%}
DIGITO [0-9]+
LETRA  [a-zA-Z]+
%%
"include"|"Include"|"INCLUDE"|"main"|"MAIN"|"Main"|"VOID"|"void"|"Void"|"printf"|"scanf"		{return P_RESERVADA;}
"define"|"DEFINE"											{return P_DEFINE;}
"return"|"Return"|"RETURN"										{return P_RETURN;}
"+"|"-"|"*"|"/"												{return OPERADOR;}
"++"													{return P_INCREMENTO;}
"--"													{return P_DECREMENTO;}
"{"													{return A_LLAVE;}
"}"													{return C_LLAVE;}
"("													{return A_PARENTESIS;}
")"													{return C_PARENTESIS;}
"]"													{return C_CORCHETE;}
"["													{return A_CORCHETE;}
";"													{return FIN_SENTENCIA;}
"int"|"double"												{return TIPO_DATO;}
"#"													{return S_NUMERAL;}
"<"													{return S_MENOR;}
">"													{return S_MAYOR;}
","													{return S_COMA;}
"="													{return S_IGUAL;}
"for"													{return P_FOR;}
"stdio.h"|"STDIO.H"|"STDLIB.H"|"stdlib.h"|"STRING.H"|"string.H"						{return LIBRERIAS;}
{DIGITO}												{return DIGITO;}
{LETRA}												{return LETRA;}
