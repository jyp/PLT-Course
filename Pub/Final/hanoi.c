#include <stdio.h>
#include <stdlib.h>

#define N 9 // how many disks

int pegs[3][N]; // the state of the game.

void show_peg(int peg) {
  int i;
  for (i = 0; i < N; i++) {
    if (pegs[peg][i] == 0) {
      printf("  ");
    } else {
      printf("%d ",pegs[peg][i]);
    }
  }
  printf("\n");
}

void show_pegs() {
  int i;
  for (i = 0; i < 3; i++) {
    show_peg(i);
  }
  printf("-----------\n");
}
void init_pegs() {
  int i;
  for (i = 0; i < N; i++) {
    pegs[0][i] = i+1;
    pegs[1][i] = 0;
    pegs[2][i] = 0;
  }
}

int take_disk(int peg) {
  int i = 0;
  while (i < N && pegs[peg][i] == 0)
    i++;
  if (pegs[peg][i] == 0)
    printf("incorrect move\n");
  int result = pegs[peg][i];
  pegs[peg][i] = 0;
  return result;
}

void put_disk(int peg, int disk) {
  int i = 0;
  while (i < N && pegs[peg][i] == 0)
    i++;
  if (i>N || i < N && disk > pegs[peg][i])
    printf("incorrect move\n");
  pegs[peg][i-1] = disk;
}

void move_disk(int source, int target) {
  put_disk(target,take_disk(source));
  show_pegs();
}


struct stack {
  int n; int s; int i; int d; int caller;
  struct stack* next;
};

struct stack* stk = NULL;

void push(int n, int s, int i, int d, int caller) {
  struct stack* prev = stk;
  stk = malloc (sizeof (struct stack));
  stk -> n = n;
  stk -> s = s;
  stk -> i = i;
  stk -> d = d;
  stk -> caller = caller;
  stk -> next = prev;
}

void pop() {stk = stk-> next;}

void move_many(int n, int s, int i, int d) {
  push(n,s,i,d,0);
 call:
  if (stk->n!=0) {
    push(stk->n-1,stk->s,stk->d,stk->i,1);
    goto call;
  loc1:
    pop();
    move_disk(stk->s,stk->d);
    push(stk->n-1,stk->i,stk->s,stk->d,2);
    goto call;
  loc2:
    pop();
  }
  int caller = stk->caller;
  if (caller == 1) goto loc1;
  if (caller == 2) goto loc2;
}

void move_many_tc(int n, int s, int i, int d) {
  push(n,s,i,d,0);
 call:
  if (stk->n!=0) {
    push(stk->n-1,stk->s,stk->d,stk->i,1);
    goto call;
  loc1:
    pop();
    move_disk(stk->s,stk->d);
    stk->n = stk -> n-1;
    int tmp = stk->s;
    stk->s = stk -> i;
    stk->i = tmp;
    goto call;
  }
  int caller = stk->caller;
  if (caller == 1) goto loc1;
}

int main() {
  init_pegs();
  show_pegs();
  move_many_tc(N,0,1,2);
  show_pegs();
  return 0;
}


