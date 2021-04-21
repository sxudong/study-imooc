package design.pattern.structural.facade.example;

/**
 * 外观模式-简化复杂子系统的访问
 * https://javap.blog.csdn.net/article/details/112426374
 * 场景：「人才津贴申报」系统，目的是帮助地方城市吸引人才，招贤纳士。
 *   津贴领取都有两个相同的前提条件：
 *     1.在当地缴纳社保。
 *     2.无犯罪记录。
 *
 *   如果是分配住房，就会再增加一个条件，就是本人和配偶名下无房产。
 *   所以为了开发这套系统，需要和社保局、公安部、住建部做对接，调用他
 *   们的接口来获取个人数据，以判断个人是否符合领取津贴的条件。
 */
public class Client {
	public static void main(String[] args) {
		Facade facade = new Facade();
		facade.getSBInfo();
		facade.getZJInfo();
		facade.getGAInfo();
	}
}
/*
查询社保,获取个人社保信息...
查询住建部,获取个人住房信息...
查询公安部,获取个人犯罪记录信息...
 */