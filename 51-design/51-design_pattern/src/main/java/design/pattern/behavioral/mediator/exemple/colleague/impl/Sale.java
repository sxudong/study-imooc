package design.pattern.behavioral.mediator.exemple.colleague.impl;

import design.pattern.behavioral.mediator.exemple.Mediator;
import design.pattern.behavioral.mediator.exemple.colleague.Colleague;

import java.util.concurrent.ThreadLocalRandom;

/**
 * 销售
 */
public class Sale extends Colleague {

	public Sale(Mediator mediator) {
		super(mediator);
		mediator.setSale(this);
	}

	// 是否畅销
	public boolean isActiveDemand(){
		return ThreadLocalRandom.current().nextBoolean();
	}

	// 正常销售
	public void sell(){
		// 需要依赖其他同事类的，让中介者去处理
		mediator.sell();
	}

	// 打折销售
	public void discountSell(){
		System.out.println("打折销售，卖完即止...");
		mediator.discountSell();
	}
}
