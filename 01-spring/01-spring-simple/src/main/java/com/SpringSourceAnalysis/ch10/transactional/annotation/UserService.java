package com.SpringSourceAnalysis.ch10.transactional.annotation;

import com.SpringSourceAnalysis.ch08.jdbc.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    @Autowired
    private UserDao userDao;

    @Transactional
    public void insertUser(){
        User user = new User();
        user.setName("张三cc");
        user.setAge(20);
        user.setSex("男");

        userDao.insert(user);
        System.out.println("插入完成");

        // 故意制造错误，使事务生效，进行回滚
        //int i = 10/0;
        throw new RuntimeException("UserService 事务异常！");
    }
}
