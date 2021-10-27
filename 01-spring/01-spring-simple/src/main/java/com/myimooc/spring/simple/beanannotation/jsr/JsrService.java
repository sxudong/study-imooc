package com.myimooc.spring.simple.beanannotation.jsr;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.annotation.Resource;
import javax.inject.Inject;
import javax.inject.Named;

/**
 * 使用@Named
 *
 * 视频：4-9 Spring Bean装配之Spring对 JSR 支持的说明
 * 单元测试类：JsrTest.java
 */
@Named //@Named 与 @Component 是等效的
public class JsrService {
    //第一种方式
//    private JsrDao jsrDao;
//
//    @Resource
//    public void setJsrDao(JsrDao jsrDao) {
//        this.jsrDao = jsrDao;
//    }

    //第二种方式
//    @Resource
//    private JsrDao jsrDao;
//
//    public void setJsrDao(JsrDao jsrDao) {
//        this.jsrDao = jsrDao;
//    }


    //第三种方式 使用JSR330标准注解
//    @Inject
//    private JsrDao jsrDao;
//
//    public void setJsrDao(@Named("jsrDao") JsrDao jsrDao) {
//        this.jsrDao = jsrDao;
//    }

    //第四种方式
    private JsrDao jsrDao;

    @Inject
    public void setJsrDao(@Named("jsrDao") JsrDao jsrDao) {
        this.jsrDao = jsrDao;
    }

    /**
     * 定义初始化方法
     */
    @PostConstruct
    public void init() {
        System.out.println("JsrService init.");
    }

    /**
     * 定义销毁方法
     */
    @PreDestroy
    public void destroy() {
        System.out.println("JsrService destroy.");
    }

    public void save() {
        jsrDao.save();
    }

}
