package design.pattern.behavioral.interpreter;

public class Test {
    public static void main(String[] args) {
        String geelyInputStr = "6 100 11 + *";
        GeelyExpressionParser expressionParser = new GeelyExpressionParser();
        int result=expressionParser.parse(geelyInputStr);
        System. out. println("解释器计算结果:" + result) ;
    }
}
/* Output:
入栈：6
入栈：100
入栈：11
出栈：11 和 100
应用算法：+
阶段结果入栈：111
出栈：111 和 6
应用算法：+
阶段结果入栈：666
解释器计算结果:666
*///~