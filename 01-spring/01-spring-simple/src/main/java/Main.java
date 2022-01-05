public class Main {
    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            System.out.println("thread run ");
        });
        System.out.println("666");
        t1.start();
    }
}
