package design.pattern.behavioral.visitor.example2.visitor.impl;

import design.pattern.behavioral.visitor.example2.Archive;
import design.pattern.behavioral.visitor.example2.visitor.Visitor;

/**
 * 报表对应的访问者实现
 */
public class StorageVisitor implements Visitor {

	@Override
	public void visit(Archive archive) {
		System.out.println("{档案编号:" + archive.getCode() + ",姓名:" + archive.getName()
				+ ",位置:" + archive.getPosition() + "}");
	}
}