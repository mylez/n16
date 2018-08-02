#include <stdio.h>
#include "ast.h"
#include "hash_table.h"


int main(int argc, char **argv)
{
	struct ast_node *root = parse_ast_root();
	int uc_addr = 0;

	struct hash_table *label_addresses = new_hash_table(10000);

	for (int i = 0; i < root->program->statement_count; i++)
	{
		struct ast_node *stmt_node = root->program->statements[i];

		switch (stmt_node->node_type)
		{
		case T_STATEMENT_VAL:
			uc_addr += 1;
			break;
		case T_STATEMENT_LABEL:
			hash_table_set(label_addresses, stmt_node->statement_label->label, uc_addr);
			break;
		}
	}

	return 0;
}