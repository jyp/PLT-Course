import java.util.HashMap;

class Lit implements Expr {
    private Integer x;

    public Lit(int x) {
        this.x = x;
    }

    public Integer eval(HashMap<String,Integer> env) {
        return x;
    }

    public Integer val() {
        return x;
    }
}
