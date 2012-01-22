public class ArrayStore {

    public static void put(Object o, Object[] in, int at) {
	in[at] = o;
    }

    public static void main(String[] args) {
	Object[] arr = new Integer[2];

	String hej = new String("Hej!");
	Integer one = new Integer(1);
	
	put(one, arr, 0);
	System.out.println("Added:"+arr[0]);

	put(hej, arr, 1);
	System.out.println("Added:"+arr[1]);
    }
}