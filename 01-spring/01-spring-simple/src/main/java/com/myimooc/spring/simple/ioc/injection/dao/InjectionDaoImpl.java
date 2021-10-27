package com.myimooc.spring.simple.ioc.injection.dao;

/**
 * DAO接口实现
 *
 * 视频：2-2 Spring注入方式
 */
public class InjectionDaoImpl implements InjectionDao {

    @Override
    public void save(String arg) {
        //模拟数据库保存操作
        System.out.println("保存数据：" + arg);
    }
}
