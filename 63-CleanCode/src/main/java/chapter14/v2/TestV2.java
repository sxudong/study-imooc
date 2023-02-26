package chapter14.v2;


public class TestV2 {
    /**
     * 代码清单 14-8 Args.java 初稿
     * com.objectmentor.utilities.args.v2.TestV2 -l -p 5 -d hello
     * working directory: G:\IDworkspace\study-imooc\63-CleanCode\target\classes
     */
    public static void main(String[] args) {
        try {
            Args arg = new Args("l,p#,d*", args); // 创建命令行参数
            boolean logging = arg.getBoolean('l');
            int port = arg.getInt('p');
            String directory = arg.getString('d');
            executeApplication(logging, port, directory);
        } catch (Exception e) {
            System.out.printf("Argument error: %s\n", e.getMessage());
        }
    }

    private static void executeApplication(boolean logging, int port, String directory) {
        System.out.println(logging); // true
        System.out.println(port); // 5
        System.out.println(directory); // hello
    }
}
