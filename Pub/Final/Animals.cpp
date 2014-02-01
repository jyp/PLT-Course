#include <cstdio>

class Animal {
public:
  virtual void sound() {
    printf("huh?\n");
  }
};

class Dog : public Animal {
public:
  virtual void sound() {
    printf("woof!!!\n");
  }
};

class Cat : public Animal {
private:
  int times;
public:
  virtual void sound() {
    // super.sound();
    times++;
    printf("meow %d\n", times);
  }
  Cat () {
    times = 0;
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
  Cat a; //TODO: Test on the derived class
  test2(a);
  test2(a);
  // test2(a);
}
