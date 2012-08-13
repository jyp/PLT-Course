#include <stdlib.h>
#include <stdio.h>

typedef struct list list;
struct list {
	unsigned n;
	list *next;
};

list primes = {2, NULL};
unsigned root = 2;

list* getNext(list *current) {
	if (current->next)
		return current->next;

	unsigned n = current->n + 1;

	list *it = &primes;
	do {
		if (n % it->n == 0) {
			n++;
			if (root*root < n)
				root++;
			it = &primes;
		} else {
			it = it->next;
		}
	} while (it && it->n <= root);

	list *new = malloc (sizeof(list));
	current->next = new;
	new->n = n;
	new->next = NULL;
	return new;
}



int main () {
	list* iter = &primes;
	for (unsigned i=1000000; i; i--) {
		//printf("%d\n", iter->n);
		iter = getNext(iter);
	}
	printf("%d\n", iter->n);
	return 0;
}

