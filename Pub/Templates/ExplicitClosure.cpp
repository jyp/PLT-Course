#include <cstdio>


// Specialize for int arguments.
struct closure {
};

int apply(closure* c, int arg) {
}

void map(closure* f, int sz, int* a) {
  // todo
}

int add3(int arg, int* env) {
  return arg + 3;
}

int addN(int arg, int* n) {
  return arg + *n;
}

// int main() {
//   closure test1 = {add3};

//   // int k = 15;
//   // closure test2 = {addN, &k};

//   int arr[5]  = {2,3,4,5,6};
//   map(&test1,5,arr);
//   for (int i = 0; i < 5; i++) {
//     printf("%d\n",arr[i]);
//   }
//   return 0;
// }

