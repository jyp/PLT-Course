#include <cstdio>

struct Animal {
  void (*sound)(Animal*);
};

void animal_sound(Animal* a) {
  printf("huh?\n");
}

// Pay attention: constructor needs to set the method pointers.
struct Animal construct_animal() {
  // TODO
}

// In derived classes, added fields should come after.

// Translate test code.
