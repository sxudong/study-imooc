package com.SpringSourceAnalysis.ch04.customtag;

import org.springframework.beans.factory.support.BeanDefinitionBuilder;
import org.springframework.beans.factory.xml.AbstractSingleBeanDefinitionParser;
import org.springframework.util.StringUtils;
import org.w3c.dom.Element;

/**
 * 4.1 自定义标签使用  《Spring源码深度解析》P69
 * 创建一个文件，实现 BeanDefinitionParser 接口，用来解析 XSD 文件中的定义和组件定义。
 */
public class UserBeanDefinitionParser extends AbstractSingleBeanDefinitionParser {
    // Element 对应的类
    @Override
    protected Class getBeanClass(Element element) {
        return User.class;
    }

    // 从 element 中解析并提取对应的元素
    @Override
    protected void doParse(Element element, BeanDefinitionBuilder bean) {
        String userName = element.getAttribute("userName");
        String email = element.getAttribute("email");
        // 将提取的数据放入到BeanDefinitionBuilder中,待到完成所有bean的解析后统一注册到beanFactory中
        if (StringUtils.hasText(userName)) {
            bean.addPropertyValue("userName", userName);
        }
        if (StringUtils.hasText(email)) {
            bean.addPropertyValue("email", email);
        }
    }
}
