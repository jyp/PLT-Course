#include <stdio.h>

main () {
  int a[2] = {1,2};
  int b[2] = {3,4};

  int *s = a;
  int *t = b;
  *t++ = *s++;

  printf("%d\n", b[0]);
}
