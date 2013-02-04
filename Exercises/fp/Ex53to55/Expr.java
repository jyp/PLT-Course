import java.util.HashMap;

interface Expr {
    public Integer eval(HashMap<String,Integer> env);
}
