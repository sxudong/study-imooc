package design.pattern.behavioral.mediator.exemple;

import design.pattern.behavioral.mediator.exemple.colleague.impl.Purchase;
import design.pattern.behavioral.mediator.exemple.colleague.impl.Sale;
import design.pattern.behavioral.mediator.exemple.colleague.impl.Stock;

/**
 * 中介者类Mediator
 */
//@Setter
public class Mediator {
	private Purchase purchase;
	private Sale sale;
	private Stock stock;

	// 采购
	public void buy(){
		if (sale.isActiveDemand()) {
			// 畅销，多进点货
			stock.increase(100);
		}else {
			// 滞销，少进点货
			stock.increase(10);
		}
	}

	// 销售
	public void sell(){
		stock.decrease(1);
		if (stock.getAmount() <= 0) {
			// 没货了，通知采购进货
			purchase.buy();
		}
	}

	// 打折销售
	public void discountSell(){
		stock.decrease(1);
	}

	// 清仓
	public void clearStock(){
		// 滞销
		// 停止采购
		purchase.stop();
		// 清仓处理，打折销售
		sale.discountSell();
	}

	public Purchase getPurchase() {
		return purchase;
	}

	public void setPurchase(Purchase purchase) {
		this.purchase = purchase;
	}

	public Sale getSale() {
		return sale;
	}

	public void setSale(Sale sale) {
		this.sale = sale;
	}

	public Stock getStock() {
		return stock;
	}

	public void setStock(Stock stock) {
		this.stock = stock;
	}
}
