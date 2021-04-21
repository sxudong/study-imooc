package design.pattern.behavioral.interpreter.example2.expression.symbol;

import design.pattern.behavioral.interpreter.example2.expression.Expression;

/**
 * 减法解析器 SubExpression
 */
public class SubExpression extends SymbolExpression {

	public SubExpression(Expression left, Expression right) {
		super(left, right);
	}

	@Override
	public int interpreter() {
		return left.interpreter() - right.interpreter();
	}
}