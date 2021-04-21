package design.pattern.structural.flyweight.section7;

/**
 * 代码清单28-17 API中的享元模式
 */
public class Test {
    public static void main(String[] args) {
        String str1 = "和谐";
        String str2 = "社会";
        String str3 = "和谐社会";
        String str4;

        str4 = str1 + str2; 
        System.out.println(str3 == str4); //false

        //String类intern方法,如果是String的对象池中有该类型的值，
        //则直接返回对象池中的对象，那当然相等了。
        str4 = (str1 + str2).intern(); 
        System.out.println(str3 == str4); //true
    } 
}
