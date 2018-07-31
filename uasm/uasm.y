%{
#include <stdio.h>

int yylex();
void yyerror();

%}

%token SIG_VAL SIG_ADDR SIG_LINE LABEL
%token COLON SEMI_COLON COMMA LPAREN RPAREN TILDE

%union
{
    char *text;
}

%type <text> statement sig_expr

%%

program
    : 
    | statement
    | program statement
    ;

statement
    : SIG_VAL COLON sig_expr SEMI_COLON         { printf("statement: %s with sign_expr: %s\n", $$, $3); }
    | SIG_ADDR COLON sig_expr SEMI_COLON    
    ;

sig_expr
    : sig_line
    | sig_expr COMMA sig_line
    ;

sig_line
    : SIG_LINE
    | TILDE sig_line
    ;

label
    : SIG_VAL
    | SIG_ADDR
    ;

%%

int main(int argc, char **argv)
{
    yyparse();
    return 0;
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
