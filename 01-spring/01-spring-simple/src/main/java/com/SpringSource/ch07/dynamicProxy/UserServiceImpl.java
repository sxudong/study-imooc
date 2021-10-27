package com.SpringSource.ch07.dynamicProxy;

public class UserServiceImpl implements UserService{

    /**
     * (non-Javadoc)
     * @see com.SpringSource.ch07.dynamicProxy.UserService#add()
     */
    @Override
    public void add() {
        System.out.println("---------------add---------------");
    }
}
