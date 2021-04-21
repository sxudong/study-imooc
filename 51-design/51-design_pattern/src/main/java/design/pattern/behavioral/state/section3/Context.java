package design.pattern.behavioral.state.section3;

/**
 * 上下文类
 */
public class Context {
	//定义出所有的电梯状态
	public final static OpenningState openningState = new OpenningState();
	public final static ClosingState closeingState = new ClosingState();
	public final static RunningState runningState = new RunningState();
	public final static StoppingState stoppingState = new StoppingState();
	
	//定一个当前电梯状态
	private LiftState liftState;
	
	public LiftState getLiftState() {
		return liftState;
	}

	public void setLiftState(LiftState liftState) {
		this.liftState = liftState;
		//把当前的环境通知到各个实现类中
		//4个状态子类靠 super.context.setLiftState(Context.closeingState); 来修改状态
		//靠 super.context.getLiftState().close(); 来委托执行动作,都得调用context来完成
		this.liftState.setContext(this);
	}
	
	public void open(){
		this.liftState.open();
	}
	
	public void close(){
		this.liftState.close();
	}
	
	public void run(){
		this.liftState.run();
	}
	
	public void stop(){
		this.liftState.stop();
	}
}
