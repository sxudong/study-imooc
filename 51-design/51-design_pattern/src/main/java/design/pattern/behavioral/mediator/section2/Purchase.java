package design.pattern.behavioral.mediator.section2;

/**
 * 采购人员
 */
public class Purchase extends AbstractColleague{
	
	public Purchase(AbstractMediator _mediator){
		super(_mediator);
	}
	//采购IBM型号的电脑
	public void buyIBMcomputer(int number){
		//需要依赖其他同事类的，让中介者去处理
		super.mediator.execute("purchase.buy", number);
	}
	
	//不在采购IBM电脑
	public void refuseBuyIBM(){
		System.out.println("不再采购IBM电脑");
	}
}
