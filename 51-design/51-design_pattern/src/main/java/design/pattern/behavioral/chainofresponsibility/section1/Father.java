package design.pattern.behavioral.chainofresponsibility.section1;

/**
 * 父亲
 */
public class Father implements IHandler {

	//未出嫁女儿来请示父亲
	public void HandleMessage(IWomen women) {
		System.out.println("女儿的请示是："+women.getRequest());
		System.out.println("父亲的答复是:同意");
	}

}
