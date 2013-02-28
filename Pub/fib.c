#include <stdio.h>
#include <stdlib.h>

int fib(int n) {
    int tmp_1,res;
    if (n < 1) {
        res = 0;
    } else if (n == 1) {
        res = 1;
    } else {
        int tmp_1 = fib(n-1);
        res = tmp_1 + fib(n-2);
    }
    return res;
}

struct stack{
    int n;
    int loc;
    int tmp_1;
    struct stack* next;
};

typedef struct stack* stk;

stk s = NULL;

void push(int n, int tmp_1, int loc) {
    stk t = malloc(sizeof(struct stack));
    t->n = n;
    t->tmp_1 = tmp_1;
    t->loc = loc;
    t->next = s;
    s = t;
}

void pop() {
    s = s->next;
}

int top_n() {
    return s->n;
}

int top_loc() {
    return s->loc;
}

int top_tmp_1() {
    return s->tmp_1;
}

int result = 0;

void fib_stk() {
    int n,tmp_1,loc;

resume:
    if (s) {
        n = top_n();
        tmp_1 = top_tmp_1();
        loc = top_loc();
        pop();
        // printf("Restored: %2d %2d %2d %2d %p\n",n,tmp_1,loc,result,s);
        if (loc == 0) goto call;
        if (loc == 1) goto loc_1;
        if (loc == 2) goto loc_2;
    } else {
        goto finished;
    }

call:
    // printf("Call:     %2d %2d %2d %2d %p\n",n,tmp_1,loc,result,s);
    if (n < 1) {
        result = 0;
    } else if (n == 1) {
        result = 1;
    } else {
        push(n,tmp_1,1);
        n = n - 1;
        goto call;
loc_1:
        tmp_1 = result;
        push(n,tmp_1,2);
        n = n - 2;
        goto call;
loc_2:
        result = tmp_1 + result;
    }
    goto resume;

finished:
    ;
}

int fib_stk_wrapper(int n) {
    push(n,0,0);
    fib_stk();
    return result;
}

int main() {
    int i;
    for (i=0; i<10; ++i) {
        printf("%d: %d %d\n", i, fib_stk_wrapper(i), fib(i));
    }
    return 0;
}

