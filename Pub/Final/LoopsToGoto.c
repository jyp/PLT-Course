#include <stdio.h>

void copy (int a[], int b[], int n) {
  int i = n;
 loop:
  i = i-1;
  a[i] = b[i];
  if ((i>0)) goto loop;
 end:
  ;
}

int input[9] = {34,23,435,124,5,4,1235,123,4};
int output[9];

int main () {
  copy(output,input,5);
  int i;
  for (i=0;i<9;i++)
    printf("%d\n",output[i]);
  return 0;
}
