import java.util.HashMap;

class Eval
{
    public Integer eval(HashMap<String,Integer> env, Expr e) {
        if (e instanceof Lit) {
            Lit u = (Lit)e;
            return u.val();
        } else if (e instanceof Add) {
            Add u = (Add)e;
            return eval(env,u.left()) + eval(env,u.right());
        } else if (e instanceof Mul) {
            Mul u = (Mul)e;
            return eval(env,u.left()) * eval(env,u.right());
        } else if (e instanceof Var) {
            Var u = (Var)e;
            return env.get(u.var());
        } else {
            return null;
        }
    }
}
