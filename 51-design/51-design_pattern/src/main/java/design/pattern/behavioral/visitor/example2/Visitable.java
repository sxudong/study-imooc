package design.pattern.behavioral.visitor.example2;

import design.pattern.behavioral.visitor.example2.visitor.Visitor;

/**
 * 定义可访问的抽象 Visitable
 * 不同的报表其实就是从 Archive档案类 中获取自己
 * 想要的数据而已，因此可以将它定义为“被访问者”。
 */
public interface Visitable {
	// 允许访问者访问
	void accept(Visitor visitor);
}