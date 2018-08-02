%{
#include <stdio.h>
#include <string.h>
#include "ast.h"

int yylex();
void yyerror(char *);

struct ast_node *ast_root;
%}

%token SIG_VAL SIG_LABEL SIG_LINE BRANCH
%token COLON SEMI_COLON COMMA LPAREN LSQRBRK RSQRBRK
%token RPAREN TILDE NUMBER_DEC NUMBER_HEX

%union
{
    struct ast_node *node;
    char *text;
}

%type <node> program sig_line sig_expr statement
%type <text> SIG_LINE SIG_LABEL SIG_VAL COLON

%%

program
: statement                             
{
    //printf("creating program: %p\n", $$);

    ast_root = malloc(sizeof(struct ast_node));
    ast_root->program = malloc(sizeof(struct program *));
    ast_root->program->statements = malloc(64*sizeof(struct ast_node *));
    ast_root->program->statement_count = 1;
    ast_root->program->statements[0] = $1;
}
| program statement                    
{ 
    //printf("adding statement %p: to program: %p\n",$2, ast_root);
    
    ast_root->program->statements[ast_root->program->statement_count++] = $2;
}
;

statement
: SIG_LABEL opt_direct_addr COLON
{
    $$ = malloc(sizeof(struct ast_node));
    $$->statement_label = malloc(sizeof(struct statement_label));
    $$->node_type = T_STATEMENT_LABEL;
    $$->statement_label->label = $1;
}
| SIG_VAL opt_direct_addr COLON sig_expr SEMI_COLON             
{
    $$ = malloc(sizeof(struct ast_node));
    $$->statement_val = malloc(sizeof(struct statement_val));
    $$->node_type = T_STATEMENT_VAL;
    $$->statement_val->label = $1;
}
| sig_expr SEMI_COLON             
{
    $$ = malloc(sizeof(struct ast_node));
    $$->node_type = T_STATEMENT_VAL;
    $$->statement_val = malloc(sizeof(struct statement_label));
    $$->statement_val->label = NULL;
}
;

opt_direct_addr
    :
    | LSQRBRK number RSQRBRK            { printf("you chose an optional direct address\n"); }
    ;

sig_expr
: sig_line                              
{ 
    $$ = malloc(sizeof(struct ast_node));
    $$->node_type = T_SIG_EXPR;
    $$->sig_expr = malloc(sizeof(struct sig_expr));
    $$->sig_expr->sig_lines = malloc(64*sizeof(struct ast_node *));
    $$->sig_expr->sig_lines[0] = $1;
    $$->sig_expr->sig_line_count = 1;
}
| sig_expr COMMA sig_line
{
    $$ = $1;
    $$->sig_expr->sig_lines[$$->sig_expr->sig_line_count++] = $3;
}
;

sig_line
: SIG_LINE 
{
    //printf("SIG_LINE\n");
    $$ = malloc(sizeof(struct ast_node));
    $$->node_type = T_SIG_LINE;
    $$->sig_line = malloc(sizeof(struct sig_line));
    $$->sig_line->inverted = 0;
    $$->sig_line->label = $1;
}
| SIG_VAL
{
    $$ = malloc(sizeof(struct ast_node));
    $$->node_type = T_SIG_LINE;
    $$->sig_line = malloc(sizeof(struct sig_line)); 
    $$->sig_line->label = $1;
}
| BRANCH LPAREN SIG_LABEL COMMA SIG_LABEL RPAREN
{
    //printf("i see what you did\n");
    $$ = malloc(sizeof(struct ast_node));
    $$->node_type = T_SIG_LINE;
    $$->sig_line = malloc(sizeof(struct sig_line)); 
    $$->sig_line->label = strdup("THIS IZ BRANCH");;
}
| TILDE sig_line                        
{
    $$ = $2; 
    $$->sig_line->inverted = !$$->sig_line->inverted;
}
;

label
    : SIG_VAL
    | SIG_LABEL
    ;

number
    : NUMBER_DEC
    | NUMBER_HEX
    ;

%%

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
