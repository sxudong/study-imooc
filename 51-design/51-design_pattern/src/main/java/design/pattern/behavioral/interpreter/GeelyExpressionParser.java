package design.pattern.behavioral.interpreter;

import java.util.Stack;

public class GeelyExpressionParser {
    private Stack<Interpreter> stack = new Stack<Interpreter>();

    public int parse(String str) {
        // 对空隔进行分割
        String[] strItemArray = str.split(" ");
        for (String symbol : strItemArray) {
            // 如果不是运算操作符，解析数字压入栈中
            if(!OperatorUtil.isOperator(symbol)) {
                // 数字解析器
                Interpreter numberExpression = new NumberInterpreter(symbol);
                stack.push(numberExpression);
                System.out.println(String.format("入栈：%d", numberExpression.interpret()));
            } else { // 是运算符号,可以计算
                Interpreter firstExpression = stack.pop();  //取出数字
                Interpreter secondExpression = stack.pop(); //取出数字
                System.out.println(String.format("出栈：%d 和 %d",
                        firstExpression.interpret(), secondExpression.interpret()));
                // 根据运算符返回对应的解析器
                Interpreter operator = OperatorUtil.getExpressionObject(firstExpression, secondExpression, symbol);
                System.out.println(String.format("应用算法：%s", operator));
                int result = operator.interpret();
                // 数字解析器
                NumberInterpreter resultExpression = new NumberInterpreter(result);
                stack.push(resultExpression); // 放回栈里面
                System.out.println(String.format("阶段结果入栈：%d", resultExpression.interpret()));
            }
        }
        int result = stack.pop().interpret();
        return result;
    }
}
