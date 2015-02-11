#include <cstdio>

class Date {
private:
  int year, month, day;
  // invariant: month >= 1 && month <= 12 && ... day ...

public:
  void check_invariant() {
    // (in reality this should be more clever)
    if (month <= 12 && month >=1 && day >= 1) //; day <= number_of_days_in(month);
      {
        // OK
      } else {
      // if we come here it means that the class breaks its own
      // invariant. That is: is is badly implemented.
      
      // throw badly_implemented_class;
    }
  }

  void shiftBy(int days) {
    day += days;
    // in reality this should be more clever
  }

  void show() {
    printf("%d-%d-%d\n",year,month,day);
  }

  Date(int y, int m, int d) {
    year  = y;
    month = m;
    day   = d;
    // check that we have a valid date here
  }
  
  Date() {
    day = 3;
    month = 2;
    year = 2013;
    // initialise to today's date by querying the OS
  }

};

int main () {
  Date appointment; // calls the default constructor
  appointment.shiftBy(7);
  appointment.show();
}
