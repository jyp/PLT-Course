class Tree<A> {
    // empty trees are represented with null
    public Tree<A> left,right;
    public A element;

    public Tree (Tree<A> l, A e, Tree<A> r) {
        left = l;
        element = e;
        right = r;
    }
}
