#include <cstdio>

struct Animal {
  void (*sound)(Animal*);
};

void animal_sound(Animal* a) {
  printf("huh?\n");
}

struct Animal construct_animal() {
  return {animal_sound};
}

struct Cat {
  void (*sound)(Cat*);
};

void cat_sound(Cat* a) {
  printf("meow\n");
}

struct Cat construct_cat() {
  return {cat_sound};
}

struct Dog {
  void (*sound)(Dog*);
};

void dog_sound(Dog* a) {
  printf("woof\n");
}

struct Dog construct_dog() {
  return {dog_sound};
}

void test(Animal* a) {
  a->sound(a);  // (1)
}

void test2(Animal a) {
   animal_sound(&a);
 }

main() {
  Cat a = construct_cat();
  test((Animal*)&(a)); // (2)
  //  test2(reinterpret_cast<struct Animal>(a));
}
