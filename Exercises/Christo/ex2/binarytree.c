#include <stdio.h>
#include <stdlib.h>

typedef struct tree tree;
struct tree {
	tree *left, *right;
	int val;
};


void addvalue(tree **prev, int val) {
	while (*prev != NULL) {
		tree *node = *prev;
		if (val > node->val) {
			prev = &node->right;
			node = node->right;
		} else if (val < node->val) {
			prev = &node->left;
			node = node->left;
		} else {
			return;
		}
	}
	tree *new = *prev;
	new = malloc(sizeof(tree));
	new->val = val;
	new->left = NULL;
	new->right = NULL;
	*prev = new;
}

int delvalue(tree **prev, int val) {
	while (*prev != NULL) {
		tree *node = *prev;
		if (val > node->val) {
			prev = &node->right;
			node = node->right;
		} else if (val < node->val) {
			prev = &node->left;
			node = node->left;
		} else {
			if (node->right == NULL) {
				*prev = node->left;
			} else if (node->left == NULL) {
				*prev = node->right;
			} else {
				*prev = node->right;
				tree *outer = node->right;
				while (outer->left != NULL) {
					outer = outer->left;
				}
				outer->left = node->left;
			}
			free(node);
			return 1;
		}
	}
	return 0;
}

void traverse(tree *node) {
	if (node == NULL)
		return;
	traverse(node->left);
	printf("%d ", node->val);
	traverse(node->right);
}

#define STACK_SIZE 1024

void traverse_explicit(tree *root) {
	tree *stack[STACK_SIZE];
	size_t size = 0;

	tree *node = root;

	do {
		while (node) {
			stack[size++] = node;
			node = node->left;
		}

		if (size) {
			tree *elem = stack[--size];
			printf("%d ", elem->val);
			node = elem->right;
		}
	} while (node || size);
}


void traverseex2(tree *node) {
	void *stack[STACK_SIZE], **s = stack;
	void *retadr = &&end;
	
loop:
	if (node == NULL)
		goto *retadr;
		
	*s++ = node;
	*s++ = retadr;
	retadr = &&ret1;
	node = node->left;
	goto loop; //traverse(node->left);
	
ret1:
	retadr = *--s;
	node = *--s;
	printf("%d ", node->val);
	node = node->right;
	goto loop;
	
end:;
}


int main() {
	tree *bst = NULL;
	addvalue(&bst, 4);
	addvalue(&bst, 10);
	addvalue(&bst, 2);
	addvalue(&bst, 23);
	addvalue(&bst, 342);
	addvalue(&bst, 0);
	addvalue(&bst, 199);
	addvalue(&bst, 24);
	addvalue(&bst, 7);
	traverse(bst);
	delvalue(&bst, 10);
	delvalue(&bst, 123);
	puts("");
	traverse(bst);
	puts("");
	traverse_explicit(bst);
	puts("");
	traverseex2(bst);
	puts("");
	return 0;
}

