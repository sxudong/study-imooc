package com.SpringSource.ch06.applicationContext.test;

import org.springframework.beans.BeansException;
import org.springframework.beans.MutablePropertyValues;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.BeanFactoryPostProcessor;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.core.Ordered;

/**
 * 10--Spring BeanPostProcessor和 BeanFactoryPostProcessor的区别
 * 在 bean 未实例化之前修改属性
 *
 * 单元测试类：BeanPostProcessorTest
 * 参考简书示例：https://www.jianshu.com/p/81349bb9859d
 */
// 《Spring源码深度解析》6.6.1 激活注册的BeanFactoryPostProcessor p147
public class MyBeanFactoryPostProcessorOne implements BeanFactoryPostProcessor, Ordered {

    /**
     * 修改dog的name属性值
     * 修改dog的作用域
     */
    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        System.out.println("BeanFactoryPostProcessor第" + getOrder() + "次被调动");
        BeanDefinition bd = beanFactory.getBeanDefinition("dog");
        if (null != bd) {
            System.out.println("dog属性值:" + bd.getPropertyValues().toString());
            MutablePropertyValues pv = bd.getPropertyValues();
            if (pv.contains("name")) {
                System.out.println("修改dog的name属性值为强强");
                pv.addPropertyValue("name", "强强");
            }
            System.out.println("修改dog的作用域为prototype\n");
            bd.setScope(BeanDefinition.SCOPE_PROTOTYPE);
        }
    }

    @Override
    public int getOrder() {
        return 0;
    }
}
