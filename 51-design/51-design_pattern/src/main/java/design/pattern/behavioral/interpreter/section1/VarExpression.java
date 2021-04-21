package design.pattern.behavioral.interpreter.section1;

import java.util.HashMap;

/**
 * 变量（元素）解析器，就是把变量和数值对应起来
 */
public class VarExpression extends Expression {
	private String key;
	
	public VarExpression(String _key){
		this.key = _key;
	}
	
	//从map中取之
	public int interpreter(HashMap<String, Integer> var) {
		return var.get(this.key);
	}

}
