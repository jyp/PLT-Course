#include "merge.h"
#include "binsearch.h"
#include "stdio.h"

int log_2(int x) {
    if (x == 0) {
        // invalid input, log(0) is undefined (or -inf)
        fprintf(stderr, "error: log on %d\n", x);
        return -1;
    } else if (x == 1) {
        return 0;
    } else {
        return 1 + log_2(x / 2);
    }
}

int pow_2(int x) {
    if (x == 0) {
        return 1;
    } else if (x % 2) {
        return 2 * pow_2(x - 1);
    } else /* even */ {
        int r = pow_2(x / 2);
        return r * r;
    }
}

// inserts e at position i into array a of length n
// (which somehow magically has room for more elements?)
void insert(int e, int i, int n, int a[]) {
    int j;
    for (j = n; j > i; j--) {
        a[j] = a[j-1];
    }
    a[i] = e;
}

void merge(int a[], int b[], int m, int n) {
    int a_size=m;
    int b_size=n;
    while (n != 0 && m != 0) {
        if (!(m > n)) {
            int t = log_2(n / m);
            int i = n + 1 - pow_2(t);
            if (a[m-1] < b[i-1]) {
                n = n - pow_2(t);
            } else {
                int k = binsearch(i-1,n,a[m-1],b)+1;
                insert(a[m-1],k-1,b_size,b);
                b_size++;
                m = m - 1;
                n = k;
            }
        } else /* m > n */ {
            int t = log_2(m / n);
            int i = m + 1 - pow_2(t);
            if (b[n-1] < a[i-1]) {
                m = m - pow_2(t);
            } else {
                int k = binsearch(i-1,m,b[n-1],a)+1;
                insert(b[n-1],k-1,a_size,a);
                a_size++;
                n = n - 1;
                m = k;
            }
        }
    }
}

