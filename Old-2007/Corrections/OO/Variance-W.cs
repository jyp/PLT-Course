interface Crap { }

interface Monoid {
  Monoid op(Monoid second);
  Monoid id();
}

struct IAMonoid: Monoid {

  public IAMonoid (int x) {
    elt = x;
  }

  public Monoid op (Monoid second) {
    return new IAMonoid (elt + ((IAMonoid) second).elt);
  }
  public Monoid id () {
    return new IAMonoid (0);
  }

  int elt;
}

class Hello
  {
    public static void Main()
    {
      IAMonoid a = new IAMonoid (0);
      Monoid b = new IAMonoid (1);
      a.op (b);
      System.Console.WriteLine("Hello World!");
    }
  }
