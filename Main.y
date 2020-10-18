%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    void yyerror(const char *);
    int yylex();
    int yylineno;
%}
%token VARIABLE IF ELSE WHILE  OR AND READ 
%token  OUTPUT INT CHAR DIGIT STRING 
%token  EQUALTO SMALLEREQUALTO BIGGEREQUALTO NOTEQUALTO
%token CONTINUE BREAK STRINGLITERAL CHARLITERAL
%left '+' '-'
%left '*' '/' '%'
%%
main:
    program { printf("Valid\n"); }
    ;
program:
        functionDeclaration
        | declarationStmts 
        | program declarationStmts
        | program functionDeclaration
        |
    ;
functionDeclaration:
        parameter '(' parameters ')'
            '{' canEmptyStmts '}'
    ;
parameters:
        parameter
        |parameter ',' parameters
    ;
parameter:
        INT VARIABLE
        | CHAR VARIABLE
        | STRING VARIABLE
        |
    ;
stmts:
        stmt
        | stmt stmts
    ;
canEmptyStmts:
        stmt
        | stmt stmts
        |
    ;
stmt:
        ifStmt
        | whileStmt
        | declarationStmts
        | assignmentStmts ';'
        | BREAK ';'
        | CONTINUE ';'
        | outputStmt ';'
        | readStmt ';'
        | functionCall ';'
        | binaryOperations ';'
        | ';'
    ;
outputStmt:
        OUTPUT '('outputParameters ')' 
    ;
outputParameters:
        outputParameter
        | outputParameters ',' outputParameter
    ;
outputParameter:
        | VARIABLE
        | DIGIT
        | CHARLITERAL
        | STRINGLITERAL
    ;
readStmt:
        READ '('readParameters ')' 
    ;
readParameters:
        readParameter
        | readParameters ',' readParameter
    ;
readParameter:
        | VARIABLE
        | DIGIT
        | CHARLITERAL
        | STRINGLITERAL

    ;
assignmentStmts:
        VARIABLE '=' DIGIT
        | VARIABLE '=' binaryOperations
        | VARIABLE '=' CHARLITERAL
        | VARIABLE '=' STRINGLITERAL
        | VARIABLE '=' VARIABLE
     ;
binaryOperations:
        binaryOperation
        | binaryOperation '+' binaryOperations
        | binaryOperation '-' binaryOperations
        | binaryOperation '/' binaryOperations
        | binaryOperation '*' binaryOperations
        | binaryOperation '%' binaryOperations
    ;
binaryOperation:
        | binaryOperationParameter '+' binaryOperationParameter
        | binaryOperationParameter '-' binaryOperationParameter
        | binaryOperationParameter '/' binaryOperationParameter
        | binaryOperationParameter '*' binaryOperationParameter
        | binaryOperationParameter '%' binaryOperationParameter
    ;
binaryOperationParameter:
        DIGIT
        |VARIABLE
    ;
functionCall:
        VARIABLE'('callParameters')' 
    ;

callParameters:
        callParameter
        |callParameter  ',' callParameters
        |
    ;
callParameter:
        VARIABLE
        |STRINGLITERAL
        |CHARLITERAL
        |DIGIT
    ;
whileStmt:
    WHILE '(' conditionalStmts ')'
        stmt
    | WHILE '(' conditionalStmts ')' '{'
        canEmptyStmts
    '}'
declarationStmts:
        INT declaration ';'
        | CHAR declaration ';'
        | STRING declaration ';'
        ;
declaration:
        VARIABLE
        | VARIABLE '=' CHARLITERAL
        | VARIABLE '=' DIGIT
        | VARIABLE '=' STRINGLITERAL
        | declaration ',' VARIABLE
        | declaration ',' VARIABLE '=' CHARLITERAL
        | declaration ',' VARIABLE '=' DIGIT
        | declaration ',' VARIABLE '=' STRINGLITERAL
        ;
ifStmt:
        IF '(' conditionalStmts ')' '{'
            canEmptyStmts
        '}'
        ELSE '{'
            canEmptyStmts
        '}'
        | IF '(' conditionalStmts ')'
            stmt
        ELSE '{'
            canEmptyStmts
        '}'
        | IF '(' conditionalStmts ')' '{'
            canEmptyStmts
        '}'
        ELSE
            stmt
        | IF '(' conditionalStmts ')'
            stmt
        ELSE
            stmt
        |IF '(' conditionalStmts ')' '{'
            canEmptyStmts
        '}'
        | IF '(' conditionalStmts ')' 
            stmt
    ;
conditionalStmts:
        conditionalStmt
        | conditionalStmts AND conditionalStmt
        | conditionalStmts OR conditionalStmt
    ;    
conditionalStmt:
        expr EQUALTO expr
        | expr '>' expr
        | expr '<' expr
        | expr AND expr
        | expr OR expr
        | expr SMALLEREQUALTO expr
        | expr BIGGEREQUALTO expr
        | expr NOTEQUALTO expr
        | expr
        
    ;
expr:
        VARIABLE
        | DIGIT
    ;


%%
void yyerror(const char *s) {
    fprintf(stderr, "line %d: %s\n", yylineno, s);
    exit(0);
}

int main(void){
    yyparse();
    return 0;
}
