package design.pattern.behavioral.interpreter.section1;

import java.util.HashMap;

/**
 * 减法解析器
 */
public class SubExpression extends SymbolExpression {

	public SubExpression(Expression _left,Expression _right){
		super(_left,_right);
	}

	//解析就是减法运算
	public int interpreter(HashMap<String, Integer> var) {
		return super.left.interpreter(var) - super.right.interpreter(var);
	}

}
