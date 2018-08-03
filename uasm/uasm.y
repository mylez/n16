%{
#include <iostream>
#include <stdio.h>
#include <string.h>

int yylex();
void yyerror(char *);

%}


%token IDENTIFIER NUMBER_HEX NUMBER_DEC

%union
{
    char *text;
}

%type <text> IDENTIFIER NUMBER_HEX NUMBER_DEC



%%

pretty: IDENTIFIER NUMBER_DEC       { std::cout << $1; };

%%

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
