package design.pattern.behavioral.chainofresponsibility.section2;

import java.util.ArrayList;
import java.util.Random;

/**
 * 《设计模式之禅》
 * 使用责任链模式改善后
 */
public class Client {
	
	public static void main(String[] args) {
		//随机挑选几个女性
		Random rand = new Random();
		ArrayList<IWomen> arrayList = new ArrayList();
		for(int i=0;i<5;i++){
			arrayList.add(new Women(rand.nextInt(4),"我要出去逛街"));
		}

		//定义三个请示对象
		Handler father = new Father();
		Handler husband = new Husband();
		Handler son = new Son();
		
		//设置请示顺序
		father.setNext(husband);
		husband.setNext(son);
		
		for(IWomen women:arrayList){
			father.HandleMessage(women);
		}
	}
}
/*
-----------没地方请示了，按不同意处理---------

--------女儿向父亲请示-------
女儿的请求是：我要出去逛街
父亲的答复是:同意

--------母亲向儿子请示-------
母亲的请求是：我要出去逛街
儿子的答复是：同意

--------母亲向儿子请示-------
母亲的请求是：我要出去逛街
儿子的答复是：同意

--------女儿向父亲请示-------
女儿的请求是：我要出去逛街
父亲的答复是:同意
 */