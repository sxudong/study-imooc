package design.pattern.structural.facade.section5;

/**
 * 子系统可以提供不同访问路径
 *
 * 模块二属于受限访问对象，只能访问methodB方法，那该如何处理呢？
 * 在这种情况下， 就需要建立两个门面以供不同的高层模块来访问，
 * 在原有的通用源码上增加一个新的门面即可。
 */
public class Facade2 {
	//引用原有的门面
	private Facade facade = new Facade();
	
	//对外提供唯一的访问子系统的方法
	public void methodB(){
		this.facade.methodB();
	}
}
