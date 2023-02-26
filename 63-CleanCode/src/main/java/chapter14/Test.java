package chapter14;

/**
 * 代码清单 14-16 Args.java 最终代码
 * https://github.com/glen9527/Clean-Code-zh
 */
public class Test {
    public static void main(String[] args) {
        try {
            Args arg = new Args("l,p#,d*", args); // 创建命令行参数
            boolean logging = arg.getBoolean('l');
            int port = arg.getInt('p');
            String directory = arg.getString('d');
            executeApplication(logging, port, directory);
        } catch (ArgsException e) {
            System.out.printf("Argument error: %s\n", e.errorMessage());
        }
    }

    private static void executeApplication(boolean logging, int port, String directory) {
        System.out.println(logging); // true
        System.out.println(port); // 5
        System.out.println(directory); // hello
    }
}
