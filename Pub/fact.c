#include <stdio.h>

int fact1 (int x) {
  if (x == 1) 
    return x;
  else
    return x * fact1(x-1);               
}


// pre-work: make order of evaluation explicit
int fact2 (int x) {  
  int y;
  if (x == 1) 
    return x;
  else {
    y = fact2(x-1);    
    return x * y;
  }
}

// put result in a global var
int result;

void fact3 (int x) {  
  if (x == 1) 
    result = x;
  else {    
    fact3(x-1);    
    // i don't need the temporary here
    result = result * x;
  }
}

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


void fact4() {  
  if (s->x == 1) 
    result = s->x;
  else {    
    push(s->x-1,0);
    fact4();
    pop();
    result = result * s->x;
  }
}

int label1 = 0;
int stop = 1;

// put the return address on the stack and do the jumps by hand
void fact5() {
  fact5:
  if (s->x == 1) 
    result = s->x;
  else {
    push(s->x-1,label1);
    goto fact5;
  label1:
    pop();
    result = result * s->x;
  }
  
  if (s->ret == label1) 
    goto label1;
}


int main(){
  printf("%d\n",fact1(5));
  printf("%d\n",fact2(5));
  fact3(5); printf("%d\n",result);
  push(5,stop); fact4(); pop(); printf("%d\n",result);
  push(5,stop); fact5(); pop(); printf("%d\n",result);
}

int result;
