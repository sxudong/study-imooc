package design.pattern.behavioral.chainofresponsibility.example2;

import design.pattern.behavioral.chainofresponsibility.example2.handler.impl.ContractHandler;
import design.pattern.behavioral.chainofresponsibility.example2.handler.Handler;
import design.pattern.behavioral.chainofresponsibility.example2.handler.impl.PersonHandler;
import design.pattern.behavioral.chainofresponsibility.example2.handler.impl.ProjectHandler;

/**
 * ChainBuilder 负责生成处理器执行链
 */
public class ChainBuilder {

	public static Handler build(){
		Handler project = new ProjectHandler();
		Handler contract = new ContractHandler();
		Handler person = new PersonHandler();
		project.setNext(contract);
		contract.setNext(person);
		return project;
	}
}
