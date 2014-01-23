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
}


