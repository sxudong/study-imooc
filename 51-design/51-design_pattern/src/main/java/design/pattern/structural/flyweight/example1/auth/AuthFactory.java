package design.pattern.structural.flyweight.example1.auth;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public class AuthFactory {
	// 缓存
	private static final ConcurrentMap<Integer, List<Auth>> map = new ConcurrentHashMap<>();
	private static AuthService authService = new AuthService();

	static{
		// 预先加载角色对应的权限信息，假设只有三种角色
		map.put(1, authService.getByRole(1));
		map.put(2, authService.getByRole(2));
		map.put(3, authService.getByRole(3));
	}

	public static List<Auth> getByRole(Integer role) {
		return map.get(role);
	}
}
