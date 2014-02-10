
interface Closure<A,B> {
    public B apply(A arg);
};

class Multiply implements Closure<Integer,Integer> {
    Integer n;
    Multiply(Integer n0) {
        n = n0;
    };
    public Integer apply(Integer arg) {
        return n*arg;
    };
};


class Add implements Closure<Integer,Integer> {
    Integer n;
    Add(Integer n0) {
        n = n0;
    };
    public Integer apply(Integer arg) {
        return n+arg;
    };
};

interface List<A> {
    public void print();
    public <B> List<B> map(Closure<A,B> f);
};

class Nil<A> implements List<A> {
    public <B> List<B> map(Closure<A,B> f) {
        return new Nil<B>();
    }
    
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
    public <B> List<B> map(Closure<A,B> f) {
        return new Cons<B>(f.apply(head),tail.map(f));
        
    }
    public void print() {
        System.out.println("Element: " + head.toString());
        tail.print();
    }
}

public class ExplicitClosure {
    public static void main(String args[]) {
        List<Integer> l = new Cons<Integer>(1234, new Cons<Integer>(5678, new Nil<Integer>()));
        // l.print();
        l.map(new Add(2)).print();
    }
}
