#include <cstdio>

class Animal {
public:
  virtual void sound() {
    printf("huh?\n");
  }
};


class Cat : public Animal {
  virtual void sound() {
    printf("meow\n");
  }
};

class Dog : public Animal {
  virtual void sound() {
    printf("woof\n");
  }
};


void test(Animal* a) {
  a->sound(); 
}

void test2(Animal a) {
  a.sound();
}

main() {
  Cat a;
  test(&a);
  // test2(a);
}
