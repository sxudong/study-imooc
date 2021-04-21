package design.pattern.behavioral.state.section2;

/**
 * 模拟电梯的动作
 *
 * 设计模式之禅
 */
public class Client {
	
	public static void main(String[] args) {
		ILift lift = new Lift();
		
		//电梯的初始条件应该是停止状态
		lift.setState(ILift.STOPPING_STATE);
		
		//首先是电梯门开启，人进去
		lift.open();
		
		//然后电梯门关闭
		lift.close();
		
		//再然后，电梯跑起来，向上或者向下
		lift.run();
		
		//最后到达目的地，电梯挺下来
		lift.stop();
	}
}
/*
电梯门开启...
电梯门关闭...
电梯上下跑起来...
电梯停止了...
 */