package design.pattern.behavioral.interpreter.example2.expression.symbol;

import design.pattern.behavioral.interpreter.example2.expression.Expression;

/**
 * 抽象的运算符解析器SymbolExpression，每个运算符必须对应左右两个操作数，否则公式无法运算
 */
public abstract class SymbolExpression extends Expression {
	protected Expression left;//左表达式
	protected Expression right;//右表达式

	public SymbolExpression(Expression left, Expression right) {
		this.left = left;
		this.right = right;
	}
}