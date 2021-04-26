package design.pattern.structural.flyweight.A1;

/**
 * 图解设计模式 第20章
 */
public class Client {
    //运行前设置工作目录为当前目录
    public static void main(String[] args) {
//        if (args.length == 0) {
//            System.out.println("Usage: java Main digits");
//            System.out.println("Example: java Main 1212123");
//            System.exit(0);
//        }
//        BigString bs;
//        bs = new BigString(args[0], false);     // 非共享
//        bs.print();
//        bs = new BigString(args[0], true);      // 共享
//        bs.print();
        BigString bs;
        bs = new BigString("13541111", false);     // 非共享
        bs.print();
        bs = new BigString("13541111", true);      // 共享
        bs.print();
    }
}
