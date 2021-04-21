package design.pattern.structural.flyweight.section1;


/**
 * 工厂类
 */
public class SignInfoFactory {
	//报名信息的对象擦很难生气
	public static SignInfo getSignInfo(){
		return new SignInfo();
	}
}
