package com.objectmentor.utilities.args.v1;

public class TestV1 {
    /**
     * 代码清单 14-1 Args的简单用法
     *
     * com.objectmentor.utilities.args.v1.Test -l -p 5 -d hello
     * working directory: G:\IDworkspace\study-imooc\63-CleanCode\target\classes
     */
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
