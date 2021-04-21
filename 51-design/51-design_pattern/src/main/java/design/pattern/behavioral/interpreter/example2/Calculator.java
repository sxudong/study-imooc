package design.pattern.behavioral.interpreter.example2;

import design.pattern.behavioral.interpreter.example2.expression.Expression;
import design.pattern.behavioral.interpreter.example2.expression.symbol.AddExpression;
import design.pattern.behavioral.interpreter.example2.expression.symbol.SubExpression;
import design.pattern.behavioral.interpreter.example2.expression.operation.VarExpression;

import java.util.Stack;

/**
 * Calculator类 毫无疑问使用栈结构来维护执行顺序
 */
public class Calculator {
	private Expression expression;
	private String exp;// 表达式

	public Calculator(String exp) {
		this.exp = exp;
		Stack<Expression> stack = new Stack<>();
		char[] chars = exp.toCharArray();//只考虑个位数
		for (int i = 0; i < chars.length; i++) {
			VarExpression varExpression = new VarExpression(String.valueOf(chars[i]));
			switch (chars[i]) {
				// 遇到运算符号 前一个数出栈，和后一个数做运算后再入栈
				case '+':
					stack.push(new AddExpression(stack.pop(), new VarExpression(String.valueOf(chars[++i]))));
					break;
				case '-':
					stack.push(new SubExpression(stack.pop(), new VarExpression(String.valueOf(chars[++i]))));
					break;
				default:
					// 遇到数字，直接入栈
					stack.push(varExpression);
			}
		}
		expression = stack.pop();
	}

	// 计算
	public void exec(){
		System.out.println("(" + exp + ") = " + expression.interpreter());
	}
}