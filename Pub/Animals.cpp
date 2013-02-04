#include <cstdio>

class Animal {
public:
  virtual void sound() {
    printf("huh?\n");
  }
};

class Cat : public Animal {
  int x;
  virtual void sound() {
    
    printf("meow %d\n",x);
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
  // test(&a);
  test2(a);
}
