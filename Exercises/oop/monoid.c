#include "stdio.h"
#include "stdlib.h"

struct monoid {
  struct monoid_vtable *vtable;
};

typedef struct monoid Monoid;

struct monoid_vtable {
  Monoid *(*op)(Monoid *this, Monoid *second);
  Monoid *(*id)(Monoid *this);
};

typedef struct monoid_vtable Monoid_Vtable;

struct integerAdditiveMonoid {
     Monoid* super;
     int elt;
};

typedef struct integerAdditiveMonoid IntegerAdditiveMonoid;

IntegerAdditiveMonoid *integerAdditiveMonoid_new(int x);

Monoid *integerAdditiveMonoid_op(Monoid *this, Monoid *second) {
     return (Monoid *) (integerAdditiveMonoid_new(((IntegerAdditiveMonoid*) this)->elt
				       + ((IntegerAdditiveMonoid *) second)->elt));
};

Monoid *integerAdditiveMonoid_id(Monoid *this) {
     return (Monoid *) (integerAdditiveMonoid_new(0));
}

Monoid_Vtable integerAdditiveMonoid_vtable = {  &integerAdditiveMonoid_op
						, &integerAdditiveMonoid_id };

IntegerAdditiveMonoid *integerAdditiveMonoid_new(int x) {
     IntegerAdditiveMonoid *this = malloc(sizeof(IntegerAdditiveMonoid));
     this->super = malloc(sizeof(Monoid));
     this->super->vtable = &integerAdditiveMonoid_vtable;
     this->elt = x;
     return this;
}

int main() {
     IntegerAdditiveMonoid *a = integerAdditiveMonoid_new(3);
     IntegerAdditiveMonoid *b = integerAdditiveMonoid_new(4);
     printf("%d\n",((IntegerAdditiveMonoid*) (a->super->vtable->op((Monoid *) a, (Monoid *) b)))->elt);
     printf("%d\n",((IntegerAdditiveMonoid*) (b->super->vtable->id((Monoid *) b)))->elt);
     free(a);
     free(b);
     return 0;
}
