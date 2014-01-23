#include <stdio.h>

int fact (int x) {
  if (x == 1)
    return x;
  else
    return x * fact1(x-1);
}

// pre-work: make order of evaluation explicit
// put result in a global var
// put arguments on a stack

struct stack{
  int x;
  int ret;
  struct stack* next;
};

typedef struct stack* stk;

stk s = NULL;

void push(int x,int ret) {
  stk t = malloc(sizeof (struct stack));
  t->x = x;
  t->ret = ret;
  t->next = s;
  s = t;
}

void pop() {
  s = s->next;
}

// put the return address on the stack.

// implement the computed jump by hand (... this is C...)

int main(){
  printf("%d\n",fact(5));
  /* push(5,stop); fact(); pop(); printf("%d\n",result); */
}

int result;
