#include "stdlib.h"
#include "merge.h"
#include "stdio.h"
#include "string.h"
#include "time.h"

#define N 3

void fill_ascending(int a[],int n) {
    int s = 0, i;
    for (i = 0; i < n; ++i) {
        s += rand() % 100 + 1;
        a[i] = s;
    }
}

int is_ascending(int a[],int n) {
    int ok = 1, i = 0;
    while (ok && i < n - 1) {
        ok &= a[i] <= a[i+1];
        i++;
    }
    return ok;
}

int find_first_zero(int a[]) {
    int i;
    for (i = 0; ; ++i) {
        if (a[i] == 0) {
            return i;
        }
    }
}

int print_array(int a[], char c, int n) {
    int i;
    for (i = 0; i < n; ++i) {
        printf("%c[%d]: %d\n", c, i, a[i]);
    }
}

int main() {
    int a[N*2 + 1];
    int b[N*2 + 1];
    int i;

    srand(time(0));

    memset(a,0,sizeof(a));
    memset(b,0,sizeof(b));

    fill_ascending(a,N);
    fill_ascending(b,N);
    // ensure that elements are unique by making a even and b odd:
    for (i = 0; i < N; i++) {
        a[i] = a[i] * 2;
        b[i] = b[i] * 2 + 1;
    }

    printf("After fill:\n");
    print_array(a,'a',N*2);
    print_array(b,'b',N*2);

    merge(a,b,N,N);

    printf("After merge:\n");
    print_array(a,'a',N*2);
    print_array(b,'b',N*2);

    int m = find_first_zero(a);
    int n = find_first_zero(b);

    printf("After zeroes found:\n");
    print_array(a,'a',m);
    print_array(b,'b',n);

    int a_ok = is_ascending(a,m);
    int b_ok = is_ascending(b,n);
    int ok = a_ok && b_ok;

    printf("Ok: %d\n", ok);
    return !ok;
}
