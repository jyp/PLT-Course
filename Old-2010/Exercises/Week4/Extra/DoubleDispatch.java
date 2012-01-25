

    class Shape {
        public String intersect (Shape s) {
    	return s.intersectShape (this);
        }
        public String intersectShape (Shape s) {
    	return "S*S";
        }    
        public String intersectRectangle (Rectangle s) {
    	return intersectShape (s);
        }    
        public String intersectCircle (Circle s) {
    	return intersectShape (s);
        }    
    }

    class Rectangle extends Shape {
        public String intersect (Shape s) {
    	return s.intersectRectangle (this);
        }
        public String intersectRectangle (Rectangle s) {
    	return "R*R";
        }    
    }

    class Circle extends Shape {
        public String intersect (Shape s) {
    	return s.intersectCircle (this);
        }
        public String intersectCircle (Circle s) {
    	return "C*C";
        }    
    }   


public class DoubleDispatch {
    public static void main (String[] args) {
	Circle c = new Circle ();
	Rectangle r = new Rectangle ();
	Shape s = new Shape ();
	
	System.out.println (s.intersect (s));
	System.out.println (s.intersect (r));
	System.out.println (s.intersect (c));
	System.out.println (r.intersect (s));
	System.out.println (r.intersect (r));
	System.out.println (r.intersect (c));
	System.out.println (c.intersect (s));
	System.out.println (c.intersect (r));
	System.out.println (c.intersect (c));
    }
}