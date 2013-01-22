#include "binsearch.h"
#include "stdio.h"

// Test on searching an array of [0*0,1*1..N*N] for elements [L..U]
#define N 5
#define S 2
#define L (-S)
#define U (N*N+S)

int main() {
    int a[N+1], i;
    for (i = 0; i <= N; ++i) {
        a[i] = i * i;
    }
    for (i = L; i <= U; ++i) {
        printf("%2d: %d\n", i, binsearch(0,N+1,i,a));
    }
    return 0;
}

