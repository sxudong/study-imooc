package design.pattern.structural.flyweight.example1.auth;

public class Auth {
	private String name;//权限名
	private String uri;//接口URI

	public Auth(String name, String uri) {
		this.name = name;
		this.uri = uri;
	}
}
