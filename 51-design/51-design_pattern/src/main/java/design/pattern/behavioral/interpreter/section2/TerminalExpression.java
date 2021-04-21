package design.pattern.behavioral.interpreter.section2;

/**
 * 终结符表达式
 *
 * 通常一个表达式中只有一个终结符表达式，
 * 类似上一个例子就是VarExpression变量解析器。
 */
public class TerminalExpression extends Expression {
	

	//通常终结符表达式只有一个，但是有多个对象
	public Object interpreter(Context ctx) {
		return null;
	}

}
