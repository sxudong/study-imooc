package com.SpringSource.ch05.factorybean;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 《Spring源码深度解析》5.1 FactoryBean的使用 P83
 *
 * 一般情况下，Spring通过反射机制利用bean的class属性指定实现类来实例化bean。
 * 在某些情况下，实例化bean的过程比较复杂，如果按照传统的方式，则需要在<bean>
 * 中提供大量的配置信息。配置方式的灵活性是受限的，Spring为此提供了一个
 * org.SpringFramwork.bean.factory.Factory的工厂类接口，用户可以
 * 通过实现该接口定制实例化bean的逻辑。
 */
public class Main {

    /**
     * 当调用getBean("car")时，Spring通过反射机制发现CarFactory实现了FactoryBean的接口，
     * 这时Spring容器就调用接口方法CarFactoryBean#getObject()返回。如果希望获取CarFactoryBean的实例，
     * 则需要使用getBean(beanName)方法时在beanName前加"&".
     */
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("factoryBean.xml");
        Car bean = (Car) context.getBean("car");
        System.out.println(bean.getBrand());
        System.out.println(bean.getMaxSpeed());
        System.out.println(bean.getPrice());
    }
}
/* Output:
超级跑车
400
2000000.0
*///~