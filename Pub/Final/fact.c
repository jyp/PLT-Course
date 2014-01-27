#include <stdio.h>
#include <stdlib.h>


struct stack{
  int x;
  int ret; // rename to caller
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

int fact (int x) {
  int tmp;
  push (x,0);
 start:
  if (s->x == 1) {
    tmp = 1;
    if (s->ret == 1) goto recCall; else return tmp;
    /* goto s->ret; */
  } else {
    push (s->x-1, 1);
    goto start;
  recCall:
    pop ();
    tmp = s->x * tmp;
    if (s->ret == 1) goto recCall; else return tmp;
    /* goto s->ret; */
  }
  return tmp;
}

// 1. pre-work: make order of evaluation explicit
// 2. put result in a var
// 3.a use the stack instead of argument
// 3.b prologue/epilogue (push 1st stack frame)
// 4. transform the call into gotos
// 6. encode translate computed goto

int main(){
  printf("%d\n",fact(5));
}

