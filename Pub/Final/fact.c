#include <stdio.h>
#include <stdlib.h>


struct stack{
  int x;
  int caller;
  struct stack* next;
};

typedef struct stack* stk;

stk s = NULL;

void push(int x,int ret) {
  stk t = malloc(sizeof (struct stack));
  t->x = x;
  t->caller = ret;
  t->next = s;
  s = t;
}

void pop() {
  s = s->next;
}

int fact (int x) {
  int tmp;
  push(x,0 /* 0 represents top-level call */);
 start:
  if (s->x == 1) {
    tmp = 1;
  }
  else {
    /* tmp = fact(x-1); */
    push(s->x-1,1 /* 1 represents the recursive call */);
    goto start;
  returnFromRecCall:
    pop();
    tmp = s->x * tmp;
  }
  /* goto s->caller; (invalid C; we must encode it)*/
  if (s->caller == 1)
    goto returnFromRecCall;
  else
    return tmp;
}

// 1. pre-work: make order of evaluation explicit
// 2. put result in a var
// 3.a use the stack instead of argument
// 3.b prologue/epilogue (push 1st stack frame)
// 4. transform the call into gotos
// 6. encode translate computed goto

int main(){
  printf("%d\n",fact(10));
}

