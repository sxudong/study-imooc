package com.SpringSourceAnalysis.ch07.aop.JdkProxy;

public class UserServiceImpl implements UserService{

    /**
     * (non-Javadoc)
     * @see com.SpringSourceAnalysis.ch07.aop.JdkProxy.UserService#add()
     */
    @Override
    public void add() {
        System.out.println("---------------add---------------");
    }
}
