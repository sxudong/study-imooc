package tx;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
public class UserService {

	@Autowired
	private UserDao userDao;

	@Transactional // 当前是一个事务方法
	public void insertUser(){
		userDao.insert();
		//otherDao.other();xxx
		System.out.println("插入完成...");
		// throw new RuntimeException("抛出异常"); // 《spring源码深度分析》P255中的事务测试方法
		int i = 10/0; // java中,如果int/int中除数为0,会抛出异常
	}
}
