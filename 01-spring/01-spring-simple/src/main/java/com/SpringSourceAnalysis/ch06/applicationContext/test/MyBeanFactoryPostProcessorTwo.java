package com.SpringSourceAnalysis.ch06.applicationContext.test;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.core.Ordered;

/**
 * 10--Spring BeanPostProcessor 和 BeanFactoryPostProcessor的区别
 * 在 bean 未实例化之前修改属性
 *
 * 单元测试类：BeanPostProcessorTest
 * 参考简书示例：https://www.jianshu.com/p/81349bb9859d
 */
// 《Spring源码深度解析》6.6.1 激活注册的BeanFactoryPostProcessor p147
public class MyBeanFactoryPostProcessorTwo implements BeanFactoryPostProcessor, Ordered {

    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        System.out.println("BeanFactoryPostProcessor第" + getOrder() + "次被调动");
    }

    @Override
    public int getOrder() {
        return 1;
    }
}
