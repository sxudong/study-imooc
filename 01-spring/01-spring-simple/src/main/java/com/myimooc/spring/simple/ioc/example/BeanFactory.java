package com.myimooc.spring.simple.ioc.example;

import java.io.InputStream;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * 它就是创建service和dao对象。
 *
 * 第一个：需要一个配置文件配置service和dao
 *       配置的内容： 唯一标识 = 全限定类名 （key = value）
 * 第二个：通过读取配置文件中配置的内容，反射创建对象
 *
 * 配置文件可以是：xml也可以是properties。
 *
 * 分析：
 * 通过创建Bean对象工厂，将service和dao对象存放在定义的一个Map中，称之为容器。在单例模式下，
 * 将此过程放在static{ }代码块中，编译过程中，就将持久层和业务层需要的对象进行存储，然后通过
 * 配置文件的key值，获取类对象。
 */
public class BeanFactory {
    //定义一个Properties对象
    private static Properties props;

    //定义一个Map用于存放我们要创建的对象，称之为容器
    private static Map<String, Object> beans;

    //使用静态代码块为Properties复制
    static {
        try {
            //实例化对象
            props = new Properties();
            //获取Properties文件的流对象
            InputStream in = BeanFactory.class.getClassLoader().getResourceAsStream("bean.properties");
            props.load(in);
            //实例化容器
            beans = new HashMap<String, Object>();
            //取出文件中所有的key
            Enumeration keys = props.keys();
            //遍历枚举
            while (keys.hasMoreElements()) {
                //取出每个key
                String key = keys.nextElement().toString();
                //根据key获取value
                String beanPath = props.getProperty(key);
                //反射创建对象
                Object value = Class.forName(beanPath).newInstance();
                //把key和value存入容器中
                beans.put(key, value);
            }
            System.out.println("beans = " + beans);
        } catch (Exception e) {
            throw new ExceptionInInitializerError("初始化异常");
        }
    }

    /**
     * 根据bean的名称获取对象
     *
     * @param beanName
     */
    public static Object getBean(String beanName) {
        return beans.get(beanName);
    }
}