#include <cstdio>

class Animal {
public:
  virtual void sound() {
    printf("huh?\n");
  }
};

// Make two derived classes; at least one should have a state.

// Test code:
void test(Animal* a) {
  a->sound();
}

void test2(Animal a) {
  a.sound();
}

main() {
  Animal a; //TODO: Test on the derived class
  // test(&a);
  // test2(a);
}
