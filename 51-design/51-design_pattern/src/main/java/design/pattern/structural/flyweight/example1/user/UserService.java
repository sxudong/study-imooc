package design.pattern.structural.flyweight.example1.user;

import design.pattern.structural.flyweight.example1.auth.AuthFactory;
import design.pattern.structural.flyweight.example1.auth.AuthService;
import design.pattern.structural.flyweight.example1.Session;

import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

public class UserService {
	private AuthService authService = new AuthService();

	public void login(String userName, String password) {
		User user = new User();
		user.setUserId(ThreadLocalRandom.current().nextLong());
		user.setUserName(userName);
		user.setPassword(password);
		user.setRole(ThreadLocalRandom.current().nextInt(2) + 1);
		// 查询用户具有的权限
		//user.setAuths(authService.getByRole(user.getRole())); //优化前
		user.setAuths(AuthFactory.getByRole(user.getRole())); //优化后
		// 用户信息存储到Session
		Session.put(UUID.randomUUID().toString(), user);
	}
}
