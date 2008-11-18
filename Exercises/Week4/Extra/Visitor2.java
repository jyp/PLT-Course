    class Shape {
        public void accept (Visitor v) {
    	v.visitShape (this);
        }
        IntersectVisitor getMyVisitor () {
    	return new ShapeIntersectVisitor(); 
        }
        public String intersect (Shape s) {
    	IntersectVisitor v = getMyVisitor();
    	s.accept (v);
    	return v.intersects;
        }

    }

    class Rectangle extends Shape {
        public void accept (Visitor v) {
    	v.visitRectangle (this);
        }
        IntersectVisitor getMyVisitor () {
    	return new RectangleIntersectVisitor(); 
        }
    }

    class Circle extends Shape {
        public void accept (Visitor v) {
    	v.visitCircle (this);
        }
        IntersectVisitor getMyVisitor () {
    	return new CircleIntersectVisitor(); 
        }
    }

    abstract class Visitor {
        public abstract void visitShape (Shape s);
        public abstract void visitRectangle (Rectangle s);
        public abstract void visitCircle (Circle s);
    }


    abstract class IntersectVisitor extends Visitor {
        String intersects = "?";
    }

    class RectangleIntersectVisitor extends IntersectVisitor {
        public void visitShape (Shape s) {
    	intersects = "R*S";
        }
        public void visitRectangle (Rectangle s) {
    	intersects = "R*R";
        }
        public void visitCircle (Circle s) {
    	intersects = "R*C";
        }
    }

    class CircleIntersectVisitor extends IntersectVisitor {
        public void visitShape (Shape s) {
    	intersects = "C*S";
        }
        public void visitRectangle (Rectangle s) {
    	intersects = "C*R";
        }
        public void visitCircle (Circle s) {
    	intersects = "C*C";
        }
    }

    class ShapeIntersectVisitor extends IntersectVisitor {
        public void visitShape (Shape s) {
    	intersects = "S*S";
        }
        public void visitRectangle (Rectangle s) {
    	intersects = "S*R";
        }
        public void visitCircle (Circle s) {
    	intersects = "S*C";
        }
    }
            


public class Visitor2 {
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