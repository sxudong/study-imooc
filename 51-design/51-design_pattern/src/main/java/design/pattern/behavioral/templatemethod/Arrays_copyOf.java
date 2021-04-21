package design.pattern.behavioral.templatemethod;
import java.util.Arrays;

public class Arrays_copyOf {
    public static void main(String[] args) {
        int a[] = {4, 3, 6, 5, 1, 2};
        int b[] = Arrays.copyOf(a, 4);
        int c[] = Arrays.copyOfRange(a, 2, 4 + 1);

        for (int i = 0; i < b.length; i++)
            System.out.print(b[i] + " "); //4 3 6 5
        System.out.println();

        for (int i = 0; i < c.length; i++)
            System.out.print(c[i] + " "); //6 5 1
        System.out.println();
    }
}