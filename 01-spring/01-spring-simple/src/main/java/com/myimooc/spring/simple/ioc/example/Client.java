package com.myimooc.spring.simple.ioc.example;

import com.myimooc.spring.simple.ioc.example.services.IAccountService;

/**
* 模拟表现层，用于调用业务层
*
 * 引入IOC的概念
 * https://blog.csdn.net/weixin_44087365/article/details/106572694
*/
public class Client {

    public static void main(String[] args) {
        //IAccountService as = new AccountServiceImpl();
        for(int i = 0; i < 3; i++) {
            //引用IOC的概念，BeanFactory底层通过反射创建对象，交给容器来管理，取代手动new对象
            IAccountService as = (IAccountService) BeanFactory.getBean("accountService");
            System.out.println(as);
            as.saveAccount();
        }
    }
}
/* Output:
beans = {accountService=com.myimooc.spring.simple.aop.example.general.services.AccountServiceImpl@448139f0, accountDao=com.myimooc.spring.simple.aop.example.general.dao.AccountDaoImpl@7cca494b}
com.myimooc.spring.simple.aop.example.general.services.AccountServiceImpl@448139f0
保存了账户
1
com.myimooc.spring.simple.aop.example.general.services.AccountServiceImpl@448139f0
保存了账户
1
com.myimooc.spring.simple.aop.example.general.services.AccountServiceImpl@448139f0
保存了账户
1
*///~