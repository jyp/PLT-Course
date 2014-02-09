
// interface Closure<A,B> {
// };

// class Multiply implements Closure<Integer,Integer> {
// };


interface List<A> {
    public void print();
    // public <B> List<B> map(Closure<A,B> f);
};

class Nil<A> implements List<A> {
    public void print() {
        System.out.println("empty.");
    }

}

class Cons<A> implements List<A> {
    A head;
    List<A> tail;
    public Cons (A h, List<A> t) {
        head = h;
        tail = t;
    }
    public void print() {
        System.out.println("Element: " + head.toString());
        tail.print();
    }
}

public class ExplicitClosure {
    public static void main(String args[]) {
        List<Integer> l = new Cons<Integer>(1234, new Cons<Integer>(5678, new Nil<Integer>()));
        // l.map(new Multiply(2)).print();
    }
}
