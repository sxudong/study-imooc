package design.pattern.structural.decorator.section3;

/**
 * 具体的构件
 */
public class ConcreteComponent extends Component {

	//具体实现
	@Override
	public void operate() {
		System.out.println("do Something");
	}
}