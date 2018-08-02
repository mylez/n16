#include <stdlib.h>
#include <string.h>

unsigned long hash_djb2(unsigned char *str)
{
    unsigned long hash = 5381;
    int c;

    while (c = *str++)
    {
    	hash = ((hash << 5) + hash) + c;
    }

	return hash;
}

struct hash_table_entry
{
	unsigned long hash;
	char *key_str;
	
	int val_int;
};

struct hash_table
{
	int size;
	struct hash_table_entry **entries;
};

struct hash_table *new_hash_table(int size)
{
	struct hash_table *t = malloc(sizeof(struct hash_table));
	t->size = size;
	t->entries = calloc(size, sizeof(struct hash_table_entry*));
	return t;
}

void destroy_hash_table(struct hash_table *t)
{
	for (int i = 0; i < t->size; i++)
	{
		if (t->entries[i] != NULL)
		{
			free(t->entries[i]->key_str);
		}
		free(t->entries[i]);
	}
	free(t->entries);
	free(t);
}

void hash_table_set(struct hash_table *t, char *key, int val)
{
	unsigned long hash = hash_djb2(key);
	int i = hash % t->size;

	printf("setting %s to %d\n", key, val);

	if (t->entries[i] == NULL)
	{
		t->entries[i] = malloc(sizeof(struct hash_table_entry));
	}
	else
	{
		free(t->entries[i]->key_str);
	}

	t->entries[i]->key_str = strdup(key);
	t->entries[i]->val_int = val;
}

int hash_table_get(struct hash_table *t, char *key)
{
	unsigned long hash = hash_djb2(key);
	int i = hash % t->size;

	if (t->entries[i] == NULL)
	{
		return 0;
	}

	return t->entries[i]->val_int;
}
