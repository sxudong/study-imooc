package design.pattern.behavioral.interpreter.example2.expression.symbol;

import design.pattern.behavioral.interpreter.example2.expression.Expression;

/**
 * 加法解析器 AddExpression
 */
public class AddExpression extends SymbolExpression {

	public AddExpression(Expression left, Expression right) {
		super(left, right);
	}

	@Override
	public int interpreter() {
		return left.interpreter() + right.interpreter();
	}
}