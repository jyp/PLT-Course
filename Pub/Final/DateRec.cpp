#include <cstdlib>
#include <cstdio>

struct Date {
  int year, month, day;

};

void check_invariant(Date* this_) {
  // (in reality this should be more clever)
  if (this_->month <= 12 && this_->month >=1 && this_->day >= 1) //; day <= number_of_days_in(month);
    {
      // OK
    } else {
    // if we come here it means that the class breaks its own
    // invariant. That is: is is badly implemented.

    // throw badly_implemented_class;
    
  }
}

void shiftBy(Date* this_, int days) {
  check_invariant(this_);
  this_->day += days;
  while (this_->day > 31)
    {
      this_->day -= 31;
      this_->month ++;
    }
  // (in reality this should be more clever)
  check_invariant(this_);
}

void show(Date* this_) {
  printf("%d-%d-%d\n",this_->year,this_->month,this_->day);
  check_invariant(this_);
}

Date default_constructor() {
  Date this_;
  this_.year = 2014;
  this_.month = 1;
  this_.day = 29;
  // in reality: initialise to today's date by querying the OS
  check_invariant(&this_);
  return this_;
}

int main () {
  Date appointment = default_constructor(); // calls the default constructor
  shiftBy(&appointment,7);
  show(&appointment);
}
