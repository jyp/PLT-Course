#include <cstdlib>
#include <cstdio>

struct Date {
  int year, month, day;
   
};
  
void shiftBy(struct Date* this_, int days) {
  this_->day += days;
    // in reality this should be more clever
}

void show(struct Date* this_) {
  printf("%d-%d-%d\n",this_->year,this_->month,this_->day);
}

Date ymd(int y, int m, int d) {
  // check that we have a valid date here
  struct Date this_;
  this_.year = y;
  this_.month = m;
  this_.day = d;
  return this_;
}
  
struct Date today() {
  struct Date this_;
  this_.year = 2013;
  this_.month = 2;
  this_.day = 3;
  // initialise to today's date by querying the OS
  return this_;
}

int main () {
  struct Date appointment = today();
  shiftBy(&appointment,7);
  show(&appointment);
}

