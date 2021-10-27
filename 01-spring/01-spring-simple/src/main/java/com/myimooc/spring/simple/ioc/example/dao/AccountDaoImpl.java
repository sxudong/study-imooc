package com.myimooc.spring.simple.ioc.example.dao;

public class AccountDaoImpl implements IAccountDao {
    public void saveAccount() {
        System.out.println("保存了账户");
    }
}
