#include <cstdio>

struct Animal {
  void (*sound)(Animal*);
};

void animal_sound(Animal* this_) {
  printf("huh?\n");
}

// Pay attention: constructor needs to set the method pointers.
struct Animal construct_animal() {
  // TODO
  Animal a;
  a.sound = animal_sound;
  return a;
}

////////////////

struct Cat {
  void (*sound)(Cat *);
  int times;
};

void cat_sound(Cat* this_) {
  animal_sound(reinterpret_cast<Animal*>(this_));
  this_->times++;
  printf("meow %d\n", this_->times);
}

// Pay attention: constructor needs to set the method pointers.
struct Cat construct_cat() {
  // TODO
  Cat a;
  a.sound = cat_sound;
  a.times = 0;
  return a;
}

////////////////

struct Dog {
  void (*sound)(Dog *);
};

void dog_sound(Dog* this_) {
  printf("woof!!!\n");
}

// Pay attention: constructor needs to set the method pointers.
struct Dog construct_dog() {
  // TODO
  Dog a;
  a.sound = dog_sound;
  return a;
}

// In derived classes, added fields should come after.

// Translate test code.


// Test code:
void test(Animal* a) {
  a->sound(a);
}

void test2(Animal a) {
  animal_sound(&a);
}

main() {
  Cat a = construct_cat(); //TODO: Test on the derived class
  // test(reinterpret_cast<Animal*>(&a));
  test2(*reinterpret_cast<Animal*>(&a));
}

