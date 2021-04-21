package design.pattern.behavioral.interpreter.example2.expression.operation;

import design.pattern.behavioral.interpreter.example2.expression.Expression;

/**
 * 操作数解析器VarExpression，很简单，将解析出的操作数字符转数字
 */
public class VarExpression extends Expression {
	private String key;

	public VarExpression(String key) {
		this.key = key;
	}

	@Override
	public int interpreter() {
		return Integer.valueOf(key);
	}
}