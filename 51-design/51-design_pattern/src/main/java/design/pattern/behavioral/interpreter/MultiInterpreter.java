package design.pattern.behavioral.interpreter;

// 乘法解析器
public class MultiInterpreter implements Interpreter {

    private Interpreter firstExpression;  // 第一个表达式
    private Interpreter secondExpression; // 第二个表达式

    public MultiInterpreter(Interpreter firstExpression, Interpreter secondExpression) {
        this.firstExpression = firstExpression;
        this.secondExpression = secondExpression;
    }

    @Override
    public int interpret() {
        return this.firstExpression.interpret() * this.secondExpression.interpret();
    }

    @Override
    public String toString() {
        return "+";
    }

}
