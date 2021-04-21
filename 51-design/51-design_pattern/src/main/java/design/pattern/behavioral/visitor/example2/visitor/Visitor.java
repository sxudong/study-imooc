package design.pattern.behavioral.visitor.example2.visitor;

import design.pattern.behavioral.visitor.example2.Archive;

/**
 * 定义访问者抽象，访问者可以访问哪些对象
 */
public interface Visitor {
	// 访问档案信息
	void visit(Archive archive);
}
