#include <stdio.h>

void updateOrNot(int &y) {
  y = 12;
}

int main(void) {
  int x = 56;
  updateOrNot(x);
  printf("%d\n",x);
  return x;
}

// use echo $? to see the result

// substitution model meaning?
// von neumann model meaning?
