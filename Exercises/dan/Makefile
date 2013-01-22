CC=gcc
CFLAGS=-I.

FILES=merge binsearch

define compile_rule
$(1).o : $(1).c $(1).h
	$(CC) -c -o $$@ $$(word 1,$$^)
endef

$(foreach file,$(FILES),$(eval $(call compile_rule,$(file))))

merge_example: merge_example.c merge.o binsearch.o
	$(CC) -o $@ $^ $(CFLAGS)

merge_test: merge_test.c merge.o binsearch.o
	$(CC) -o $@ $^ $(CFLAGS)

binsearch_test: binsearch_test.c binsearch.o
	$(CC) -o $@ $^ $(CFLAGS)

all: merge_example merge_test binsearch_test

clean:
	rm -rf *.o

.PHONY: all
