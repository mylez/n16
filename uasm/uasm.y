%{
#include <stdio.h>
#include <string.h>
#include "ast.h"

int yylex();
void yyerror();

struct ast_node *ast_root;
%}

%token SIG_VAL SIG_LABEL SIG_LINE
%token COLON SEMI_COLON COMMA LPAREN RPAREN TILDE NUMBER_DEC NUMBER_HEX

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
    printf("creating program: %p\n", $$);

    ast_root = malloc(sizeof(struct ast_node));
    ast_root->program = malloc(sizeof(struct program *));
    ast_root->program->statements = malloc(64*sizeof(struct ast_node *));
    ast_root->program->statement_count = 1;
    ast_root->program->statements[0] = $1;
}
| program statement                    
{ 
    printf("adding statement %p: to program: %p\n",$2, ast_root);
    
    ast_root->program->statements[ast_root->program->statement_count++] = $2;
}
;

statement
: SIG_LABEL COLON
{
    $$ = malloc(sizeof(struct ast_node));
    $$->statement_label = malloc(sizeof(struct statement_label));
    $$->node_type = T_STATEMENT_LABEL;
    $$->statement_label->label = $1;
}
| SIG_VAL COLON sig_expr SEMI_COLON             
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
    printf("SIG_LINE\n");
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

%%

int main(int argc, char **argv)
{
    int res = yyparse(); 
    printf("%s\n", res ? "failure" : "success");
   
    const int signal_bus_width = 40;
    bool signal_rom[0x100][signal_bus_width];

    int uc_addr = 0;
    for (int i = 0; i < ast_root->program->statement_count; i++)
    {
        struct ast_node *n = ast_root->program->statements[i];
        char *label;
        switch (n->node_type)
        {
        case T_STATEMENT_VAL:
            label = n->statement_val->label;
            uc_addr += 1;
            break;
        case T_STATEMENT_LABEL:
            label = n->statement_label->label;
            break;
        default:
            break;
        }

        printf("statement %d: %p %s\n", i, n, label);
    }
    return res;
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
