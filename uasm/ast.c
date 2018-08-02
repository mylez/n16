#include <stdlib.h>
#include "uasm.tab.h"
#include "ast.h"

struct ast_node *get_ast_root()
{
    yyparse();
    return ast_root;
}
