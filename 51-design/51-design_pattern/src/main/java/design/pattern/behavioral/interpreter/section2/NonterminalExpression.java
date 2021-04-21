package design.pattern.behavioral.interpreter.section2;

/**
 * 非终结符表达式
 *
 * 类似上一个例子的AddExpression(加法解析器)和SubExpression(减法解析器)
 */
public class NonterminalExpression extends Expression {
	
	//每个非终结符表达式都会对其他表达式产生依赖
	public NonterminalExpression(Expression... expression){
		
	}
	
	public Object interpreter(Context ctx) {
		//进行文法处理
		return null;
	}

}
