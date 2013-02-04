#include <cstdio>

struct closure {
  int (* p)(int arg, int* env);
  int* env;
};

int apply(closure* c, int arg) {
  return c->p(arg,c->env);
}

void map(closure* f, int sz, int* a) {
  for (int i = 0; i<sz; i++) {
    a[i] = apply(f,a[i]);
  }
}

int add3(int arg, int* env) {
  return arg + 3;
}

int addN(int arg, int* n) {
  return arg + *n;
}

int main() {
  closure test1 = {add3};

  // int k = 15;
  // closure test2 = {addN, &k};

  int arr[5]  = {2,3,4,5,6};
  map(&test1,5,arr);
  for (int i = 0; i < 5; i++) {
    printf("%d\n",arr[i]);
  }
  return 0;
}



