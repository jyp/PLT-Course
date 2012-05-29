#include <iostream>

template <class T>
class Arith {
public:
	virtual T eval() = 0;
};


template <class T>
class Num : public Arith<T> {
private:
	T val;
public:
	Num(T val) {
		this->val = val;
	}

	virtual T eval() {
		return val;
	}
};

template <class T>
class Plus : public Arith<T> {
	Arith<T> *a1, *a2;
public:
	Plus(Arith<T> *a1, Arith<T> *a2) {
		this->a1 = a1;
		this->a2 = a2;
	}

	virtual T eval() {
		return a1->eval() + a2->eval();
	}
};


template <class T>
class Minus : public Arith<T> {
	Arith<T> *a1, *a2;
public:
	Minus(Arith<T> *a1, Arith<T> *a2) {
		this->a1 = a1;
		this->a2 = a2;
	}

	virtual T eval() {
		return a1->eval() - a2->eval();
	}
};


using namespace std;
int main() {
	Arith<int> *expr = new Minus<int>(
		new Plus<int>(new Num<int>(3), new Num<int>(4))
		, new Num<int>(20)
		);
	cout << expr->eval();
	return 0;
}
