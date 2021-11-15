
package controller;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import pojo.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * 处理器类
 *	负责处理业务逻辑。
 * 	达内 spring day01
 */
// AbstractController extends WebContentGenerator implements Controller {
public class UserController extends AbstractController {

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest httpServletRequest,
												 HttpServletResponse httpServletResponse) throws Exception {
		List<User> userList = new ArrayList<User>();
		User userA = new User();
		User userB = new User();
		userA.setUsername("张三");
		userA.setAge(27);
		userB.setUsername("李四");
		userB.setAge(37);
		userList.add(userA);
		userList.add(userB);
		return new ModelAndView("userlist", "users", userList);
	}
}
