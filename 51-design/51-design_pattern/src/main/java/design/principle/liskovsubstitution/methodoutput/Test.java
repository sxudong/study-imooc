package design.principle.liskovsubstitution.methodoutput;

/**
 * Created by geely
 */
public class Test {
    public static void main(String[] args) {
        Child child = new Child();
        System.out.println(child.method());
    }
}
/* Output:
子类method被执行
{message=子类method被执行}
 */