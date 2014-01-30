#include <cstdio>

class Date {
  // what is public/private?
  int year, month, day;

  void check_invariant() {
    // what is the invariant?
    // what do we do if it's invalid
    // when should we call the invariant.
  }
  
  void shiftBy(int days) {
    // TODO
  }

  void show() {
    printf("%d-%d-%d\n",year,month,day);
  }

  Date(int y, int m, int d) {
    // TODO
  }

  Date() {
    // TODO: initialise to today's date by querying the OS
  }

};

int main () {
  Date appointment; // calls the default constructor
  appointment.shiftBy(7);
  appointment.show();
}
