package design.pattern.structural.flyweight.example1;

import design.pattern.structural.flyweight.example1.user.User;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

public class Session {
	private static final ConcurrentMap<String, User> MAP = new ConcurrentHashMap<>();

	public static void put(String sessionId, User user) {
		MAP.put(sessionId, user);
	}
}
