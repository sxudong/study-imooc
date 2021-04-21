package uml.association;

/**
 * 类图—关联关系（Association）： 关联关系实际上就是类与类之间的联系
 * 关联具有导航性：即双向关系或单向关系。
 */
// 单向一对一关系
//public class Person {
//	private IDCard card;
//}
//
//class IDCard{}

// 双向一对一关系
public class Person {
	private IDCard card;
}

class IDCard{
	private Person person;
}
