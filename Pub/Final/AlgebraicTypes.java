class Product<A,B> {
    A a;
    B b;
};

interface List<A> {
    public void print();
    public List<A> append(List<A> xs);
    public List<A> reverse();
};

class Nil<A> implements List<A> {
    public void print() {
        System.out.println("empty.");
    }
    public List<A> append(List<A> xs) {
        return xs;
    }
    public List<A> reverse() {
        return this;
    };
}

class Cons<A> implements List<A> {
    A head;
    List<A> tail;
    public Cons (A h, List<A> t) {
        head = h;
        tail = t;
    }
    public List<A> append(List<A> ys) {
        return new Cons<A>(this.head,tail.append(ys));
    }
    public List<A> reverse() {
        return tail.reverse().append(new Cons<A>(head, new Nil<A>()));
    }
    public void print() {
        System.out.println("Element: " + head.toString());
        tail.print();
    }
}

public class AlgebraicTypes {
    public static void main(String args[]) {
        List<String> l = new Cons<String>("one", new Cons<String>("two", new Nil<String>()));
        l.reverse().print();
        // l.print();
    }
}
