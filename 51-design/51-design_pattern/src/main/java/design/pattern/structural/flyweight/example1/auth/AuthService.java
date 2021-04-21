package design.pattern.structural.flyweight.example1.auth;

import java.util.ArrayList;
import java.util.List;

public class AuthService {

	// 查询role具有的权限
	public List<Auth> getByRole(Integer role){
		return mockData(role);
	}

	// 模拟数据
	private List<Auth> mockData(Integer role) {
		List<Auth> list = new ArrayList<>();
		switch (role){
			case 1://普通用户
				list.add(new Auth("查看", "/look.html"));
			case 2://管理员
				list.add(new Auth("新增", "/add.html"));
				list.add(new Auth("修改", "/update.html"));
				list.add(new Auth("删除", "/delete.html"));
			case 3://超级管理员
				list.add(new Auth("无所不能", "/almighty.html"));
			default:;
		}
		return list;
	}
}
