#include <stdlib.h>
#include "ast.h"

extern int yyparse();
extern struct ast_node *ast_root;

struct ast_node *parse_ast_root()
{
	if (yyparse() == 0)
	{
		return ast_root;
	}

	return NULL;
}