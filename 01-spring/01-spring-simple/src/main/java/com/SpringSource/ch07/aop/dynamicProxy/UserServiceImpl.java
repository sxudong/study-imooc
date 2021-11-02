package com.SpringSource.ch07.aop.dynamicProxy;

public class UserServiceImpl implements UserService{

    /**
     * (non-Javadoc)
     * @see com.SpringSource.ch07.aop.dynamicProxy.UserService#add()
     */
    @Override
    public void add() {
        System.out.println("---------------add---------------");
    }
}
