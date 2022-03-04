package com.SpringSourceAnalysis.ch05.ioc;

import org.springframework.beans.factory.support.BeanDefinitionBuilder;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;

/**
 * 相关知识点-GenericBeanDefinition
 *
 * 哪里用到了呢？
 *  1、XML中的 <bean parent=""> ，简单说如果你设置了 ，User extends SuperUser
 *  其 SuperUser 里面的值会合并到的 User 所继承的 SuperUser 中。
 *  2、也可以通过 API 的方式来处理，上面就是通过 API 的方式处理，为啥只说明 API
 *  是因为最终 XML 也是通过 API 的方式处理的， 在注解时代并没有这个属性，如果需要
 *  也可以通过API的方式处理。
 * ————————————————
 * 版权声明：本文为CSDN博主「森林猿」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
 * 原文链接：https://blog.csdn.net/vistaed/article/details/108005205
 */
public class GenericBeanDefinitionDemo {

    public static void main(String[] args) throws ClassNotFoundException {
        DefaultListableBeanFactory beanFactory = new DefaultListableBeanFactory();

        //创建通用的BeanDefinition
        BeanDefinitionBuilder userBeanBuilder = BeanDefinitionBuilder.genericBeanDefinition(User.class);
        userBeanBuilder.addPropertyValue("adder","北京");
        userBeanBuilder.setParentName("superUser"); // 设置父类

        // 父类：小明
        BeanDefinitionBuilder superUser = BeanDefinitionBuilder.genericBeanDefinition(SuperUser.class);
        superUser.addPropertyValue("name","小明");
        superUser.addPropertyValue("age",18);

        // 注册beanDefinition
        beanFactory.registerBeanDefinition("superUser", superUser.getBeanDefinition());
        beanFactory.registerBeanDefinition("user", userBeanBuilder.getBeanDefinition());

        User bean = beanFactory.getBean(User.class);
        System.out.println(bean); // User{adder='北京'} SuperUser{name='小明', age=18}
    }
}

class User extends SuperUser{
    private String adder;

    public String getAdder() {
        return adder;
    }

    public void setAdder(String adder) {
        this.adder = adder;
    }

    @Override
    public String toString() {
        return "User{" +
                "adder='" + adder + '\'' +
                "} " + super.toString();
    }
}


class SuperUser {
    private String name;
    private Integer age;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "SuperUser{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
