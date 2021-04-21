package design.pattern.behavioral.mediator.exemple.colleague.impl;

import design.pattern.behavioral.mediator.exemple.Mediator;
import design.pattern.behavioral.mediator.exemple.colleague.Colleague;

/**
 * 采购
 */
public class Purchase extends Colleague {

	public Purchase(Mediator mediator) {
		super(mediator);
		mediator.setPurchase(this);
	}

	public void buy(){
		// 需要依赖其他同事类的，让中介者去处理
		mediator.buy();
	}

	public void stop(){
		System.out.println("停止采购...");
	}
}
