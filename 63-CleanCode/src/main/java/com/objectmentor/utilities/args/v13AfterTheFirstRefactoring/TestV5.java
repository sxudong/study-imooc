package com.objectmentor.utilities.args.v13AfterTheFirstRefactoring;

import java.text.ParseException;

public class TestV5 {
    /**
     * 代码清单 14-12 首次重构后
     *
     * com.objectmentor.utilities.args.v5.TestV5 -l -p 5 -d hello
     * working directory: G:\IDworkspace\study-imooc\63-CleanCode\target\classes
     */
    public static void main(String[] args) {
        try {
            Args arg = new Args("l,p#,d*", args); // 创建命令行参数
            boolean logging = arg.getBoolean('l');
            int port = arg.getInt('p');
            String directory = arg.getString('d');
            executeApplication(logging, port, directory);
        } catch (ParseException e) {
            System.out.printf("Argument error: %s\n", e.getMessage());
        }
    }

    private static void executeApplication(boolean logging, int port, String directory) {
        System.out.println(logging); // true
        System.out.println(port); // 5
        System.out.println(directory); // hello
    }
}
