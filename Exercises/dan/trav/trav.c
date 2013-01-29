#include "stdio.h"
#include "stdlib.h"

struct tree {
    int v;
    struct tree *l, *r;
};

typedef struct tree Tree;

Tree *branch(Tree *l,int v,Tree *r) {
    Tree *t = malloc(sizeof(Tree));
    t->v = v;
    t->l = l;
    t->r = r;
    return t;
}

// preorder dfs traversal
void dfs(Tree *t) {
    if (t != NULL) {
        printf("%d\n",t->v);
        dfs(t->l);
        dfs(t->r);
    }
}

struct stack {
    Tree *top;
    struct stack *next;
};

typedef struct stack Stack;

Stack *s = NULL;

void push(Tree *t) {
    Stack *ns = malloc(sizeof(Stack));
    ns->top = t;
    ns->next = s;
    s = ns;
}

Tree *pop() {
    Tree *t = s->top;
    Stack *ns = s->next;
    free(s);
    s = ns;
    return t;
}

void dfs_stack(Tree *u) {
    push(u);
    do {
        Tree *t = pop();
        if (t != NULL) {
            printf("%d\n",t->v);
            push(t->r);
            push(t->l);
        }
    } while (s);
}

int main() {
    Tree *root = branch(branch(NULL,2,branch(NULL,5,NULL)),1,branch(branch(NULL,3,NULL),4,NULL));
    printf("Recursive:\n");
    dfs(root);
    printf("With explicit stack:\n");
    dfs_stack(root);
    return 0;
}

