package design.pattern.structural.flyweight.example1.user;

import design.pattern.structural.flyweight.example1.auth.Auth;
import lombok.Data;

import java.util.List;

@Data
public class User {
	private Long userId;
	private String userName;
	private String password;
	private Integer role;
	private List<Auth> auths; //用户具有的权限列表
}
