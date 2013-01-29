#include "binsearch.h"

// Returns i s.t. l <= i < u, and i is the largest i such that
// e <= a[i]. a needs to be a sorted, ascending array.
// TODO: implement quickcheck and test this
int binsearch(int l, int u, int e, int a[]) {
    if (u <= l) {
        return l;
    } else {
        // Calculate middle, being careful for when the sum of l and u is bigger
        // than max int
        int m = (u - l) / 2 + l;
        if (a[m] < e) {
            return binsearch(m+1,u,e,a);
        } else if (a[m] > e) {
            return binsearch(l,m,e,a);
        } else /* a[m] == e */ {
            return m;
        }
    }
}

