package design.pattern.structural.adapter.section3;

import java.util.HashMap;
import java.util.Map;

/**
 * 用户工作信息
 */
public class OuterUserOfficeInfo implements IOuterUserOfficeInfo {

	/* 
	 * 员工的工作信息，比如职位了等
	 */
	public Map getUserOfficeInfo() {
		HashMap officeInfo = new HashMap();
		
		officeInfo.put("jobPosition","这个人的职位是BOSS...");
		officeInfo.put("officeTelNumber", "员工的办公电话是....");
		
		return officeInfo;
	}

}
