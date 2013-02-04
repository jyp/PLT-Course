#include "stdio.h"
#include "merge.h"

int a[30] = {87, 503, 512};
int b[30] = {61, 154, 170, 275, 426, 509, 612, 653, 677, 703, 765, 897, 908};

int main() {
    int i;
    merge(a,b,3,13);
    for(i = 0; i < 10; i++) {
        printf("a[%2d]: %d\n",i+1,a[i]);
    }
    for(i = 0; i < 20; i++) {
        printf("b[%2d]: %d\n",i+1,b[i]);
    }
}




