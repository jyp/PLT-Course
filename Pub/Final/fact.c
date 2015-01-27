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

// make order of eval. explicit
int fact2 (int x) {
  int tmp;
  if (x == 1)
    return x;
  else {
    tmp = fact2(x-1);
    return x * tmp;
  }
}

// put result in a global var
int result;

int fact3 (int x) {
  int tmp;
  if (x == 1)
    result = x;
  else {
    fact3(x-1);
    tmp = result;
    result = x * tmp;
  }
  return result;
}

// put arguments on a stack
void fact4() {
  if (s->x == 1)
    result = 1;
  else {
    push(s->x-1,0);
    fact4();
    pop();
    result = s->x * result;
  }
}

// put the return address on the stack and do the jumps by hand
void fact5() {
 fact5:
  if (s->x == 1)
    result = 1;
  else {
    push(s->x-1,1);
    goto fact5;
  lab1:
    pop();
    result = s->x * result;
  }
  if (s->caller == 1) goto lab1;
}


// put the stack initialisation in the function
int fact6 (int x) {
  push(x,0 /* 0 represents top-level call */);
 start:
  if (s->x == 1) {
    result = 1;
  }
  else {
    /* result = fact(x-1); */
    push(s->x-1,1 /* 1 represents the recursive call */);
    goto start;
  lab1:
    pop();
    result = s->x * result;
  }
  /* goto s->caller; (invalid C; we must encode it)*/
  if (s->caller == 1)
    goto lab1;
  return result;
}

// re-construct loops
int fact7 (int x) {
  push(x,0 /* 0 represents top-level call */);
  // !! not quite right: if s->x is == 1, return immediately
  while (!(s->x == 1)) {
    push(s->x-1,1 /* 1 represents the recursive call */);
  };
  result = 1;
  do {
    pop();
    result = s->x * result;
  } while (s->caller == 1);
  return result;
}

// 1. pre-work: make order of evaluation explicit
// 2. put result in a var
// 3.a use the stack instead of argument
// 3.b prologue/epilogue (push 1st stack frame)
// 4. transform the call into gotos
// 6. encode translate computed goto

int main(){
  printf("%d\n",fact7(10));
  return 0;
}

