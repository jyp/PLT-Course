#include <stdio.h>


int fact (int x,int y) {
  if (x == 1)
    return y;
  else
    return fact(x-1,y*x);
}

// translate the call directly.
// recreate a loop

int main(){
  printf("%d\n",fact(5,1));
  return 0;
}

/*
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
*/
