package com.SpringSource.ch03.lookupMethod.app;

import com.SpringSource.ch03.lookupMethod.bean.User;

/**
 * 4.解析子元素 lookup-method
 * 《Spring源码深度解析》P44
 */
public abstract class GetBeanTest {

    public void showMe() {
        this.getBean().showMe();
    }

    public abstract User getBean();

}
