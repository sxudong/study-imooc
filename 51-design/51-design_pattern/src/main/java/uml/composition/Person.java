package uml.composition;

/**
 * 类图—组合关系（Composition）
 *
 * 该关系也是整体与部分的关系，但是整体与部分不可以分开。
 *
 * 案例：定义实体 Person 与 IDCard、Head，那么 Head 和 Person 就是组合关系，IDCard 和 Person 就是聚合关系。
 *
 * 解释一下：IDCard不会随着Person的创建而创建，只有用到它的时候，可以通过set方法赋值，但是Head不一样，
 * 只要Person创建，Head一定会被创建，这就是聚合和组合的区别。
 */
public class Person{
	private IDCard card;	//聚合
	private Head head = new Head();	//组合

	public void setIDCard(IDCard card){
		this.card = card;
	}
}

class IDCard{}
class Head{}
