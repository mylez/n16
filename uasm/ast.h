#ifndef UASM_AST_H
#define UASM_AST_H

#include <stdbool.h>

enum NODE_TYPE
{
    _,
    T_PROGRAM,
    T_STATEMENT_VAL,
    T_STATEMENT_LABEL,
    T_SIG_EXPR,
    T_SIG_LINE
};

struct program
{
    struct ast_node **statements;
    int statement_count;
};

struct statement_val
{
    char *label;
    struct sig_expr **sig_exprs;
    int sig_expr_count;
};

struct statement_label
{
    char *label;
};

struct sig_expr
{
    struct ast_node **sig_lines;
    int sig_line_count;
};

struct sig_line
{
    char *label;
    bool inverted;
};

struct ast_node
{
    enum NODE_TYPE node_type;
    
    struct program *program;
    struct statement_val *statement_val;
    struct statement_label *statement_label;
    struct sig_expr *sig_expr;
    struct sig_line *sig_line;
};

struct ast_node *parse_ast_root();

#endif
