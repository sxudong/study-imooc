package design.pattern.behavioral.state.section3;

/**
 * 模拟电梯的动作
 *
 * 设计模式之禅
 */
public class Client {
	
	public static void main(String[] args) {
		Context context = new Context();
		context.setLiftState(new ClosingState());
		
		context.open();
		context.close();
		context.run();
		context.stop();
		context.open();
	}
}
/*
电梯门开启...
电梯门关闭...
电梯上下跑...
电梯停止了...
电梯门开启...
 */