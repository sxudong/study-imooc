package design.pattern.structural.facade.example;

import design.pattern.structural.facade.example.subsystem.GongAnSystem;
import design.pattern.structural.facade.example.subsystem.SheBaoSystem;
import design.pattern.structural.facade.example.subsystem.ZhuJianSystem;

// 外观类
public class Facade {
	private SheBaoSystem sheBaoSystem = new SheBaoSystem();
	private ZhuJianSystem zhuJianSystem = new ZhuJianSystem();
	private GongAnSystem gongAnSystem = new GongAnSystem();

	// 获取社保信息
	public void getSBInfo(){
		this.sheBaoSystem.getSBInfo();
	}

	// 获取住房信息
	public void getZJInfo(){
		this.zhuJianSystem.getZJInfo();
	}

	// 获取犯罪记录
	public void getGAInfo(){
		this.gongAnSystem.getGAInfo();
	}
}
