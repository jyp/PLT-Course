import java.util.HashMap;

class Var implements Expr {
    private String v;

    public Var(String v) {
        this.v = v;
    }

    public Integer eval(HashMap<String,Integer> env) {
        return env.get(v);
    }

    public String var() {
        return v;
    }
}
