package design.pattern.behavioral.mediator.exemple;

import design.pattern.behavioral.mediator.exemple.colleague.impl.Purchase;
import design.pattern.behavioral.mediator.exemple.colleague.impl.Sale;
import design.pattern.behavioral.mediator.exemple.colleague.impl.Stock;

/**
 * 中介者模式-进销存管理
 * https://javap.blog.csdn.net/article/details/111937745
 *
 * 几乎所有的企业都离不开「进销存管理」系统，这个系统分为三个模块：采购、销售和库存。
 *   1.采购：负责采购产品，依赖于销售模块，需要根据产品的销售情况酌情采购，畅销就多采购，滞销就少采购。
 *   2.销售：负责销售产品，依赖库存和采购，无货可卖了就要通知采购。
 *   3.库存：负责提供产品的库存情况，如果某项产品卖不出去积压了，就要通知采购模块停止采购，通知销售模块打折处理。
 */
public class Client {
	public static void main(String[] args) {
		Mediator mediator = new Mediator();
		Purchase purchase = new Purchase(mediator);
		Sale sale = new Sale(mediator);
		Stock stock = new Stock(mediator);
		
		purchase.buy();
		sale.sell();
		stock.clearStock();
	}
}
