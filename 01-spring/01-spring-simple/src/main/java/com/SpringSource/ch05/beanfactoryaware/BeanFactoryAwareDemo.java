package com.SpringSource.ch05.beanfactoryaware;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.BeanFactoryAware;

/**
 * 定义 BeanFactoryAware类型的bean
 */
public class BeanFactoryAwareDemo implements BeanFactoryAware {
    private BeanFactory beanFactory;
    //声明 bean 的时候，Spring会自动注入BeanFactory
    @Override
    public void setBeanFactory(BeanFactory beanFactory) throws BeansException {
        this.beanFactory = beanFactory;
    }

    public void testAware(){
        //通过 hello 这个 bean id 从 beanFactory 获取实例
        Hello hello = (Hello) beanFactory.getBean("hello");
        hello.say();
    }
}
