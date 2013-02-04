import java.util.HashMap;

class Mul implements Expr {
    private Expr l,r;

    public Mul(Expr l,Expr r) {
        this.l = l;
        this.r = r;
    }

    public Integer eval(HashMap<String,Integer> env) {
        return l.eval(env) * r.eval(env);
    }

    public Expr left() {
        return l;
    }

    public Expr right() {
        return r;
    }
}
