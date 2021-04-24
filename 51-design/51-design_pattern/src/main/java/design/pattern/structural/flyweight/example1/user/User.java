package design.pattern.structural.flyweight.example1.user;

import design.pattern.structural.flyweight.example1.auth.Auth;

import java.util.List;

//@Data
public class User {
	private Long userId;
	private String userName;
	private String password;
	private Integer role;
	private List<Auth> auths; //用户具有的权限列表

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Integer getRole() {
		return role;
	}

	public void setRole(Integer role) {
		this.role = role;
	}

	public List<Auth> getAuths() {
		return auths;
	}

	public void setAuths(List<Auth> auths) {
		this.auths = auths;
	}
}
