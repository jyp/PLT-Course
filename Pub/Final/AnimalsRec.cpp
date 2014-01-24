#include <cstdio>

struct Animal {
  void (*sound)(Animal*);
};

void animal_sound(Animal* a) {
  printf("huh?\n");
}

struct Animal construct_animal() {
  Animal a = {animal_sound};
  return a;
}

struct Cat {
  void (*sound)(Cat*);
  int x;
};

void cat_sound(Cat* a) {
  printf("meow %d\n",a->x);
}

struct Cat construct_cat() {
  Cat c = {cat_sound, 87654};
  return c;
}

struct Dog {
  void (*sound)(Dog*);
};

void dog_sound(Dog* a) {
  printf("woof\n");
}

struct Dog construct_dog() {
  Dog d = {dog_sound};
  return d;
}

void test(Animal* a) {
  a->sound(a);  // (1)
}

void test2(Animal a) {
  animal_sound(&a);
  // a.sound(&a);
 }

main() {
  Cat c = construct_cat();
  test((Animal*)&c); // (2)
  Animal a = { (void (*)(Animal*)) c.sound};
  test2(a);
  //  test2(reinterpret_cast<struct Animal>(a));
}
