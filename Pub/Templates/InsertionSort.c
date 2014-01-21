#include <stdio.h>

void sort (int a[], int n) {
  int i,j;
  for (i=1; i<n; i++) {
    // invariant: the array is sorted up to and excluding i.
    int tmp = a[i];
    j = i;
    /* printf ("Iteration i=%d, tmp=%d\n", i, tmp); */
    while (j > 0 && tmp < a[j-1]) {
      // invariant: tmp is smaller than a[j] to a[i+1]
      a[j] = a[j-1];
      j = j-1;
    }
    a[j] = tmp;
  }
}

int input[9] = {34,23,435,124,5,4,1235,123,4};

int main () {
  sort(input,9);
  int i;
  for (i=0;i<9;i++)
    printf("%d\n",input[i]);
  return 0;
}
