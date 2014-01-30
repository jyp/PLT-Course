#include <stdio.h>

int x = 777;
int y = 888;

int* p = &x;

int main () {
  printf("%x\n", (unsigned int) &p);
  printf("%d\n", *(p+1));
}
