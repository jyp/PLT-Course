#include <iostream>
using namespace std;

class MyDate {
public:int y, m, d; 
public:
  MyDate(int year, int month, int day);
};

MyDate::MyDate(int year, int month, int day) {
    y = year;
    m = month;
    d = day; 
}

int main() {
 MyDate today (2007,10,30);
 MyDate tomorrow (2007,10,31); 
 cout << "A:" << today.d << endl;
 cout << "A:" << tomorrow.d << endl;

 tomorrow = today;  // copy semantics

 cout << "B:" << today.d << endl;
 cout << "B:" << tomorrow.d << endl;

 tomorrow.d = 4711;  

 cout << "C:" << today.d << endl;
 cout << "C:" << tomorrow.d << endl;

 cout << "Now reference sem. via pointers" << endl;

 // reference semantics via copying pointers
 MyDate* today_ptr = new MyDate(2007,10,30);
 MyDate* tomorrow_ptr = new MyDate(2007, 10, 31);   // aliasing


 cout << "A:" << today_ptr->d << endl;
 cout << "A:" << tomorrow_ptr->d << endl;

 tomorrow_ptr = today_ptr;  // copy semantics

 cout << "B:" << today_ptr->d << endl;
 cout << "B:" << tomorrow_ptr->d << endl;

 tomorrow_ptr->d = 4711;  

 cout << "C:" << today_ptr->d << endl;
 cout << "C:" << tomorrow_ptr->d << endl;


 cout << "=====" << endl;

 // copies today to tomorrow_ptr referenced
 *tomorrow_ptr = today;

 cout << "A:" << today.d << endl;
 cout << "A:" << tomorrow_ptr->d << endl;

 tomorrow_ptr->d = 4711;  

 cout << "B:" << today.d << endl;
 cout << "B:" << tomorrow_ptr->d << endl;


 return 0;
}
