#include <stdio.h>

int x = 777;
int y = 888;

int* p = &x;

int main () {
  printf("%lx\n", (long) &p);
  printf("%d\n", *(p+1));
  return 0;
}
