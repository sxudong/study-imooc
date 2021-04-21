package design.pattern.behavioral.interpreter;

public class OperatorUtil {
    public static boolean isOperator(String symbol) {
        return (symbol.equals("+") || symbol.equals("*"));
    }

    /**
     *
     * @param firstExpression 表达式1
     * @param secondExpression 表达式2
     * @param symbol 运算符
     * @return
     */
    public static Interpreter getExpressionObject(Interpreter firstExpression,
                                                  Interpreter secondExpression,
                                                  String symbol) {
        if(symbol.equals("+")) {
            // 加法解析器
            return new AddInterpreter(firstExpression, secondExpression);
        } else if (symbol.equals("*")) {
            // 乘法解析器
            return new MultiInterpreter(firstExpression, secondExpression);
        }
        return null; // 可以写成一个空的解析器
    }
}
