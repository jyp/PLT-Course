#include <stdio.h>
#include <stdlib.h>

int fib(int n) {
    int tmp,res;
    if (n < 1) {
        res = 0;
    } else if (n == 1) {
        res = 1;
    } else {
        int tmp = fib(n-1);
        res = tmp + fib(n-2);
    }
    return res;
}

struct stack{
    int n;
    int loc; // location of the caller. 0 = global caller
    int tmp;
    struct stack* next;
};

typedef struct stack* stk;

stk s = NULL;

void push(int n, int tmp, int loc) {
    stk t = malloc(sizeof(struct stack));
    t->n = n;
    t->tmp = tmp;
    t->loc = loc;
    t->next = s;
    s = t;
}

void pop() {
    s = s->next;
}

#define UNDEFINED (-1)

int fib_stk(int arg) {
  int tmp, loc, result;
  // push the initial stack frame. Global caller has code 0
  push(arg,UNDEFINED,0); 
 call:
  if (s->n < 1) {
    result = 0;
  } else if (s->n == 1) {
    result = 1;
  } else {
    push(s->n-1,UNDEFINED,1); // tmp not initialised here
    goto call;
  loc_1:        
    tmp = result;
    push(s->n-2,tmp,2); 
    goto call;
  loc_2:        
    result = tmp + result;
  }
  // return:
  tmp = s->tmp; // restore local vars
  loc = s->loc; // remember the caller
  pop(); 
  // jump to the caller
  if (loc == 0) return result; // if global, return.
  if (loc == 1) goto loc_1;
  if (loc == 2) goto loc_2;
}

int main() {
    int i;
    for (i=0; i<10; ++i) {
        printf("%d: %d %d\n", i, fib_stk(i), fib(i));
    }
    return 0;
}

