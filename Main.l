%{
    #include "y.tab.h"
%}
%option yylineno
digit [0-9]
letter [a-zA-Z]
alpha [a-zA-Z]|[_]|[0-9]
whiteSpace [ \n\t]
%%
string                      return STRING;
int                         return INT;
char                        return CHAR;
if                          return IF;
else                        return ELSE;
while                       return WHILE;
break                       return BREAK;
continue                    return CONTINUE;
output                      return OUTPUT;
read                        return READ;
"&&"                        return AND;
"||"                        return OR;
"=="                        return EQUALTO;
"!="                        return NOTEQUALTO;
"<="                        return SMALLEREQUALTO;
">="                        return BIGGEREQUALTO;
\"[^"\n]*["\n]              return STRINGLITERAL;
\'[^'\n]['\n]               return CHARLITERAL;
({letter}({alpha}*))        return VARIABLE;
{digit}+                    return DIGIT;
[/][*][a-zA-Z0-9_ ;,"'=.\n\t]*[*][/]   {;}
{whiteSpace}  {;}
#include.* {;}
. return yytext[0];

%%
int yywrap(){
    return 1;
}
