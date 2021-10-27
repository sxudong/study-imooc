package com.myimooc.spring.simple.ioc.interfaces;

/**
 * 接口实现
 */
public class OneInterfaceImpl implements OneInterface {

    @Override
    public void say(String arg) {
        System.out.println("ServiceImpl say: " + arg);
    }

}
