#define intswap(X,Y) {int temp=X; X=Y; Y=temp;} 

int main() {
  int temp=1, b=2; intswap(temp,b); printf("%d, %d\n", temp, b);
}
