#include <stdio.h>

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

void move_many(int n, int source, int intermediate, int target) {
  if (n != 0) {
    move_many(n-1,source,target,intermediate);
    move_disk(source,target);
    move_many(n-1,intermediate,source,target);
  }
}

int main() {
  init_pegs();
  show_pegs();
  move_many(N,0,1,2);
  show_pegs();
  return 0;
}


