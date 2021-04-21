package design.pattern.structural.composite.section5;

import java.util.ArrayList;

/**
 * 树叶构件
 */
public class Leaf extends Component {	
	@Deprecated //注解告诉调用者该方法已经失效了
	public void add(Component component) throws UnsupportedOperationException {
		//空实现,直接抛弃一个“不支持请求”异常
		throw new UnsupportedOperationException();
	}
	
	@Deprecated
	public void remove(Component component)throws UnsupportedOperationException {
		//空实现
		throw new UnsupportedOperationException();
	}
	
	@Deprecated
	public ArrayList<Component> getChildren()throws UnsupportedOperationException {
		//空实现
		throw new UnsupportedOperationException();
	}
}
