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

/*
struct IAMonoid: Monoid {

  public IAMonoid (int x) {
    elt = x;
  }

  public IAMonoid op (Monoid second) {
    return new IAMonoid (elt + ((IAMonoid) second).elt);
  }
  public IAMonoid id () {
    return new IAMonoid (0);
  }

  int elt;
}


struct IAMonoid: Monoid {

  public IAMonoid (int x) {
    elt = x;
  }

  public Monoid op (Monoid second) {
    return new IAMonoid (elt + ((IAMonoid) second).elt);
    // The cast is not safe anyway!!!
  }
  public Monoid id () {
    return new IAMonoid (0);
  }
  int elt;
}


struct IAMonoid: Monoid {

  public IAMonoid (int x) {
    elt = x;
  }

  public Monoid op (Monoid second) {
    return new IAMonoid (elt + ((IAMonoid) second).elt);
    // The cast is not safe anyway!!!
  }
  public Monoid id () {
    return new IAMonoid (0);
  }
  int elt;
}

*/