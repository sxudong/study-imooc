package com.myimooc.spring.simple.beanannotation.injection.service;

import com.myimooc.spring.simple.beanannotation.injection.dao.InjectionDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 服务接口实现
 *
 * 视频：4-2 Spring Bean装配之 Autowired 注解说明-1
 */
@Service
public class InjectionServiceImpl implements InjectionService {

    @Autowired
    private InjectionDao injectionDao;

    //构造器注入
//    @Autowired
//    public InjectionServiceImpl(InjectionDao injectionDao) {
//        this.injectionDao = injectionDao;
//    }

    //set注入
//    @Autowired
//    public void setInjectionDao(InjectionDao injectionDao) {
//        this.injectionDao = injectionDao;
//    }

    @Override
    public void save(String arg) {
        //模拟业务操作
        System.out.println("Service接收参数：" + arg);
        arg = arg + ":" + this.hashCode();
        injectionDao.save(arg);
    }

}
