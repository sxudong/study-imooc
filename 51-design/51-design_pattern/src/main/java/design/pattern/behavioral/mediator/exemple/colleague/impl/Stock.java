package design.pattern.behavioral.mediator.exemple.colleague.impl;

import design.pattern.behavioral.mediator.exemple.Mediator;
import design.pattern.behavioral.mediator.exemple.colleague.Colleague;

/**
 * 库存
 */
public class Stock extends Colleague {
	private int amount = 0;

	public Stock(Mediator mediator) {
		super(mediator);
		mediator.setStock(this);
	}

	// 增加库存
	public void increase(int num) {
		this.amount += num;
		System.out.println("增加库存:" + this.amount);
	}

	// 减少库存
	public void decrease(int num) {
		this.amount -= num;
		System.out.println("减少库存:" + this.amount);
	}

	// 当前还有多少库存?
	public int getAmount() {
		return amount;
	}

	// 清仓处理
	public void clearStock() {
		// 需要依赖其他同事类的，让中介者去处理
		mediator.clearStock();
	}
}
