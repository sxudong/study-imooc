package design.pattern.behavioral.mediator.imooic;

/**
 * 24-2 中介者模式coding
 *
 * Servlet Filter、Spring Interceptor 都使用的责任链模式
 */
public class Test {
    public static void main(String[] args) {
        User geely = new User("Geely");
        User tom = new User("Tom");

        geely.sendMessage("hey!Geelyl");
        tom.sendMessage("hey!Tom");
    }
}
/* Output:
Fri Jun 26 14:14:01 CST 2020[ldc]:hey!Geely
Fri Jun 26 14:14:01 CST 2020[ghl]:hey!Tom
*///~
