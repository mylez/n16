%{
#include <stdio.h>
#include "ast.h"

int yylex();
void yyerror();

%}

%token SIG_VAL SIG_ADDR SIG_LINE LABEL
%token COLON SEMI_COLON COMMA LPAREN RPAREN TILDE

%union
{
    struct ast_node *node;
    char *text;
}

%%

program
//    : 
    : statement
    | program statement
    ;

statement
    : label COLON                               { printf("label\n"); }
    | sig_expr SEMI_COLON                       { printf("expr\n"); }
    ;

sig_expr
    : sig_line
    | sig_expr COMMA sig_line
    ;

sig_line
    : SIG_LINE                                  { printf("signal line\n"); }
    | TILDE sig_line                            { printf("inverted signal line\n"); }
    ;

label
    : SIG_VAL
    | SIG_ADDR
    ;

%%

int main(int argc, char **argv)
{
    if (yyparse() == 0)
    {
        printf("success\n");
        return 0;
    }
    printf("failure\n");
    return 1;
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
