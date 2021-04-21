package design.pattern.behavioral.observer.section2;

/**
 * 这个Client就是我们，用我们的视角看待这段历史
 */
public class Client {
	
	public static void main(String[] args) {
		//定义出韩非子
		HanFeiZi hanFeiZi = new HanFeiZi();
		
		//然后这里我们看看韩非子在干什么
		hanFeiZi.haveBreakfast();
		
		//韩非子娱乐了
		hanFeiZi.haveFun();
		
	}
}
