#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>


void build_floyd(size_t n, bool graph[n][n]) {
	size_t i, j, k;
	
	for (k=0; k < n; k++)
	for (i=0; i < n; i++)
	for (j=0; j < n; j++) {
		graph[i][j] |= (graph[i][k] & graph[k][j]);
	}
}

bool connected(size_t n, bool graph[n][n], size_t a, size_t b) {
	return graph[a][b];
	
}

#define N 7

int main() {
	bool test[N][N] = 
	{ {1,1,0,0,0,0,0}
	, {1,1,1,0,0,0,0}
	, {0,1,1,0,0,0,0}
	, {0,0,0,1,1,1,0}
	, {0,0,0,1,1,1,0}
	, {0,0,0,1,1,1,1}
	, {0,0,0,0,0,1,1}
	};
	
	build_floyd(N, test);
	
	printf("A-G: %d\n", connected(N, test, 0, 6));
	printf("A-C: %d\n", connected(N, test, 0, 2));
	
	return 0;
}
