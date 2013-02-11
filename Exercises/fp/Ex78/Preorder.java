class Preorder {

    private int visited;

    public Preorder () {}

    // not thread-safe
    public Tree<Integer> preorder(Tree<?> t) {
        visited = 0;
        return go(t);
    }

    private Tree<Integer> go(Tree<?> t) {
        if (t == null) {
            return null;
        } else {
            Tree<Integer> l,r;
            int my_visit_number = visited;
            visited++;
            l = go(t.left);
            r = go(t.right);
            return new Tree<Integer> (l,my_visit_number,r);
        }
    }

}
