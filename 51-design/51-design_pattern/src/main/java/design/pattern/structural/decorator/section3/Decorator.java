package design.pattern.structural.decorator.section3;

/**
 * 装饰角色
 */
public abstract class Decorator extends Component {
	private Component component = null;
	
	//通过构造函数传递被修饰者
	public Decorator(Component _component){
		this.component = _component;
	}
	
	//委托给被修饰者执行
	@Override
	public void operate() {
		this.component.operate();
	}
}