class Branch<A> implements Tree<A> {
    private Tree<A> left,right;
    private A element;

    public Branch (Tree<A> l, A e, Tree<A> r) {
        left = l;
        element = e;
        right = r;
    }
}
