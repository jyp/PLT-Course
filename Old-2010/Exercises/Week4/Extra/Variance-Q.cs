interface Crap { }

interface Monoid {
  Monoid op(Monoid second);
  Monoid id();
}

struct IAMonoid: Monoid {

  public IAMonoid (int x) {
    elt = x;
  }

  public IAMonoid op (IAMonoid second) {
    return new IAMonoid (elt + second.elt);
  }
  public IAMonoid id () {
    return new IAMonoid (0);
  }

  int elt;
}

