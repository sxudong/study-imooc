package design.pattern.behavioral.interpreter;

// 加法解析器
public class AddInterpreter implements Interpreter {

    private Interpreter firstExpression;  // 第一个表达式
    private Interpreter secondExpression; // 第二个表达式

    public AddInterpreter(Interpreter firstExpression, Interpreter secondExpression) {
        this.firstExpression = firstExpression;
        this.secondExpression = secondExpression;
    }

    @Override
    public int interpret() {
        return this.firstExpression.interpret() + this.secondExpression.interpret();
    }

    @Override
    public String toString() {
        return "+";
    }

}
