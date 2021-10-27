package com.myimooc.spring.simple.beanannotation.injection.dao;

import org.springframework.stereotype.Repository;

/**
 * DAO接口实现
 *
 * 视频：4-2 Spring Bean装配之 Autowired 注解说明-1
 */
@Repository
public class InjectionDaoImpl implements InjectionDao {

    @Override
    public void save(String arg) {
        //模拟数据库保存操作
        System.out.println("保存数据：" + arg);
    }
}
