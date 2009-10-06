

   class Shape {
       public String intersect (Shape s) {
   	return "Shape * Shape";
       }
   }

   class Rectangle extends Shape {
       public String intersect (Shape s) {
   	if (s instanceof Rectangle) 
   	    return "Rectangle * Rectangle";
   	else 
   	    return super.intersect(s);
       }
   }

   class Circle extends Shape {
       public String intersect (Shape s) {
   	if (s instanceof Circle) 
   	    return "Circle * Circle";
   	else 
   	    return super.intersect(s);
       }
   }

public class SingleDispatch {
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