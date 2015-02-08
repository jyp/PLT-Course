#include <stdlib.h>
#include <stdio.h>

struct stack{ 
  int x;
  int y;
  int ret;
  struct stack* next;
};

typedef struct stack* stk;

stk s = NULL;



void push(int x,int y,int ret) {
  stk t = malloc(sizeof (struct stack));
  t->x = x;
  t->y = y;
  t->ret = ret;
  t->next = s;
  s = t;
}

void pop() {
  s = s->next;
}

int fact1 (int x,int y) {
  if (x == 1)
    return y;
  else
    return fact1(x-1,y*x);
}

// make order of eval. explicit

int fact2 (int x,int y) {
  if (x == 1)
    return y;
  else {
    y = y*x;
    x = x-1;
    return fact2(x,y);
  }
}

// put result in a global var
int result;

void fact3 (int x,int y) {
  if (x == 1)
    result = y;
  else {
    fact3(x-1,y*x);
  }
}

// put arguments on a stack
void fact4() {
  if (s->x == 1)
    result = s->y;
  else {
    push(s->x-1,s->y*s->x,0);
    fact4();
    pop();
  }
}

int label1 = 0;
int stop = 1;

// put the return address on the stack and do the jumps by hand
void fact5() {
  fact5:
  if (s->x == 1)
    result = s->y;
  else {
    push(s->x-1,s->y*s->x,label1);
    goto fact5;
  label1:
    pop();
  }
  
  if (s->ret == label1)
    goto label1;
}

// tail-call optim. (no need to save on the stack: we return before we
// can make any use of the saved stuff)

void fact6() {
  fact6:
  if (s->x == 1)
    result = s->y;
  else {
    s->y = s->y*s->x;
    s->x = s->x-1;
    goto fact6;
  label1:
    ;
  }
  
  if (s->ret == label1)
    goto label1;
}

// remove dead code
void fact7() {
  fact7:
  if (s->x == 1) 
    result = s->y;
  else {
    s->y = s->y*s->x;
    s->x = s->x-1; 
    goto fact7;
  }
}

//note now there is max 1 frame in the stack
// return the result as for a normal function.

int fact8(int x) {
  int y = 1;
  start:
  if (x == 1)
    result = y;
  else {
    y = y*x;
    x = x-1;
    goto start;
  }
  return y;
}

// recreate a loop
int fact9(int x) {
  int y = 1;
  while (x /= 1) {
    y = y*x;
    x = x-1;
  }
  return y;
}




int main(){
  printf("%d\n",fact1(5,1));
  printf("%d\n",fact2(5,1));
  fact3(5,1); printf("%d\n",result);
  push(5,1,stop); fact4(); pop(); printf("%d\n",result);
  push(5,1,stop); fact5(); pop(); printf("%d\n",result);
  push(5,1,stop); fact6(); pop(); printf("%d\n",result);
  push(5,1,stop); fact7(); pop(); printf("%d\n",result);
  printf("%d\n",fact8(5));
  printf("%d\n",fact9(5));
  return 0;
}


