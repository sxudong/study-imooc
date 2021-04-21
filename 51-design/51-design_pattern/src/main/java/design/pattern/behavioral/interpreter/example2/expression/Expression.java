package design.pattern.behavioral.interpreter.example2.expression;

/**
 * 解析器抽象 Expression
 */
public abstract class Expression {
	// 解释表达式并获得结果
	public abstract int interpreter();
}