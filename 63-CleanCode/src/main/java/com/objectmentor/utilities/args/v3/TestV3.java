package com.objectmentor.utilities.args.v3;


public class TestV3 {

    /**
     * 代码清单 14-9 更早期的一个版本，只支付布尔类型
     * com.objectmentor.utilities.args.v3.TestV3 -l
     * working directory: G:\IDworkspace\study-imooc\63-CleanCode\target\classes
     */
    public static void main(String[] args) {
        Args arg = new Args("l,p#,d*", args); // 创建命令行参数
        boolean logging = arg.getBoolean('l');
        executeApplication(logging);
    }

    private static void executeApplication(boolean logging) {
        System.out.println(logging); // true
    }
}
