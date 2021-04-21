package design.pattern.behavioral.interpreter.section2;

import java.util.Stack;

/**
 * 客户类
 * 通常该类为一个封装类
 */
public class Client {

	public static void main(String[] args) {
		// Context 环境角色（运算变量和值，采用上一个例字的HashMap代替）
		Context ctx = new Context();
		//通常定一个语法容器，容纳一个具体的表达式，通常为ListArray,LinkedList,Stack等类型
		Stack<Expression> stack = null;
		/*
		for(;;){
			//进行语法判断，并产生递归调用
		}
		*/
		//产生一个完整的语法树，由各各个具体的语法分析进行解析
		Expression exp = stack.pop();
		
		//具体元素进入场景
		exp.interpreter(ctx);
	}
}
