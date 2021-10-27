package com.myimooc.spring.simple.postprocessor;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;

/**
 * bean后置处理器
 * 将 Spring 的后置处理器 PostProcessor 配置到 Spring 配置文件中
 *
 * Spring 中的后置处理器 BeanPostProcessor 讲解 https://www.cnblogs.com/sishang/p/6576665.html
 */
public class PostProcessorDemo implements BeanPostProcessor {

    // 注意: 接口中两个方法不能返回 null，如果返回 null 那么在后续初始化方法将报空指针异常或者通过
    // getBean() 方法获取不到 bena 实例对象,因为后置处理器从 Spring IoC 容器中取出 bean 实例
    // 对象没有再次放回 IoC 容器中。

    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        //bean初始化之前，要干点什么或者什么都不干，但是干不干都要把人家给返回回去

        if ("injectionDao".equals(beanName)) { //过滤掉bean实例ID为narCodeService
            return bean;
        }
        System.out.println("后置处理器处理bean=【" + beanName + "】初始化方法前");
        User user = (User) bean;
        System.out.println(user.getName());
        user.setName("李四");
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return bean;
    }

    /**
     * 只能修改
     */
    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        //bean已经初始化完了，这时候你想干点什么或者什么都不干，和上面一样，都要给人家返回回去

        if ("injectionDao".equals(beanName)) {
            return bean;
        }
        System.out.println("后置处理器处理bean=【" + beanName + "】初始化方法后");
        //测试改回来
//        User user = (User) bean;
//        user.setName("张三");
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return bean;
    }
}
