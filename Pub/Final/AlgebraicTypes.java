interface List<A> {
    public List<A> append (List<A> xs);
    public List<A> reverse();
    public void print();
};

class Cons<A> implements List<A> {
  public A head;
  public List<A> tail;

  public Cons(A h, List<A> t) {
      head = h;
      tail = t;
  }

  public List<A> append (List<A> xs) {
      return new Cons<A>(head,tail.append(xs));
  };

  public List<A> reverse() {
      return tail.reverse().append(new Cons<A>(head,new Nil<A>()));
  }
  public void print () {
      System.out.println("Cons: " + head.toString());
      tail.print();
  }
};

class Nil<A> implements List<A> {
    public List<A> append (List<A> xs) {
        return xs;
    };
    public List<A> reverse () {
        return this;
    }
    public void print () {
        System.out.println("Nil: ");
    }
};

public class AlgebraicTypes {
    public static void main(String args[]) {
        List<String> l = new Cons<String>("one", new Cons<String>("two", new Nil<String>()));
        l.reverse().print();
        l.print();
    }
}
