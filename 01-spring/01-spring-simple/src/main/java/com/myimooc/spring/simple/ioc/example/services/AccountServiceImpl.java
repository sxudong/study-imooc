package com.myimooc.spring.simple.ioc.example.services;

import com.myimooc.spring.simple.ioc.example.BeanFactory;
import com.myimooc.spring.simple.ioc.example.dao.IAccountDao;

public class AccountServiceImpl implements IAccountService {

    //private IAccountDao accountDao = new AccountDaoImpl(); //自己管理用new方式创建对象

    //引入IOC的概念，底层由BeanFactory反射创建对象
    private IAccountDao accountDao = (IAccountDao) BeanFactory.getBean("accountDao");

    public void saveAccount() {
        int i = 1;
        //private IAccountDao accountDao = new AccountDaoImpl();
        //accountDao = (IAccountDao) BeanFactory.getBean("accountDao");
        accountDao.saveAccount();
        System.out.println(i);
        i++;
    }
}
