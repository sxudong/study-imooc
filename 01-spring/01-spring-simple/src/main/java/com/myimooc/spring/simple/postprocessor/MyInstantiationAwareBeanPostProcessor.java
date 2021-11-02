package com.myimooc.spring.simple.postprocessor;

import org.springframework.beans.BeansException;
import org.springframework.beans.PropertyValues;
import org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor;
import org.springframework.cglib.proxy.Enhancer;

/**
 * spring源码解析之---InstantiationAwareBeanPostProcessor解析
 * https://blog.csdn.net/mamamalululu00000000/article/details/107233549
 *
 * springboot之BeanPostProcessor功能及例子（一）
 * https://blog.csdn.net/qq_18297675/article/details/87957540
 *
 * 在 bean 实例化前后做一些事情。注意，是先实例化才到初始化方法的！
 * InstantiationAwareBeanPostProcessor 的方法 postProcessBeforeInstantiation ，从名字就可以看出 在创建 Bean 时候调用(而且是 创建之前)。
 * 打断点看源码，是在 AbstractAutowireCapableBeanFactory#createBean() 中执行了“实例化前解决”方法 resolveBeforeInstantiation(),该方法
 * 中调用了 applyBeanPostProcessorsBeforeInstantiation()和 applyBeanPostProcessAfterInstantiation()，这里面调用了 BeanPostProcessor接口 方法。
 * 是在 doCreateBean() 实例化之前执行的，返回了一个代理。
 */
public class MyInstantiationAwareBeanPostProcessor implements InstantiationAwareBeanPostProcessor {

    @Override
    public Object postProcessBeforeInstantiation(Class<?> beanClass, String beanName) throws BeansException {
        //如果什么都不做，返回null，代表走默认实例化的逻辑
        //如果在这里做了什么，那么就返回你指定实例化逻辑产生的对象
        if (beanClass == BeanTest.class) {
            System.out.println("beanName: " + beanName + "执行..postProcessBeforeInstantiation 方法");

            //Enhancer相当于CGLIB，在此处使用代理对bean处理后返回。
            Enhancer enhancer = new Enhancer();
            enhancer.setSuperclass(beanClass);
            enhancer.setCallback(new BeanTestMethodInterceptor());
            BeanTest beanTest = (BeanTest) enhancer.create();
            return beanTest;
        }
        return null;
    }

    /**
     * 实例化后不修改对象，返回true/false
     * @param bean
     * @param beanName
     * @return boolean
     * @throws BeansException
     */
    @Override
    public boolean postProcessAfterInstantiation(Object bean, String beanName) throws BeansException {
        //实例化完了之后，如果这里返回true，代表这个bean的属性会被正常set进去，如果是false，那么就会跳过，spring给的建议是一般都要返回true。
        System.out.print("beanName: " + beanName + "执行..postProcessAfterInstantiation 方法\n");
        return true;
    }

    @Override
    public PropertyValues postProcessProperties(PropertyValues pvs, Object bean, String beanName)
            throws BeansException {
        //null，相当于什么都没做
        //返回不是null，相当于将返回的变量值替换原来的变量赋值
        System.out.println("beanName: postProcessProperties 执行postProcessProperties...");
        return pvs;
    }


    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("执行初始化前 postProcessBeforeInitialization...");
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("执行初始化后 postProcessAfterInitialization...");
        return bean;
    }
}
