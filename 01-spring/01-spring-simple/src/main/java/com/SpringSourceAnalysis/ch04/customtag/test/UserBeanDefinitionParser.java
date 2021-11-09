package com.SpringSourceAnalysis.ch04.customtag.test;

import org.springframework.beans.factory.support.BeanDefinitionBuilder;
import org.springframework.beans.factory.xml.AbstractSingleBeanDefinitionParser;
import org.springframework.beans.factory.xml.ParserContext;
import org.w3c.dom.Element;


/**
 * 对自定义的标签进行解析
 * https://cloud.tencent.com/developer/article/1718111
 */
public class UserBeanDefinitionParser extends AbstractSingleBeanDefinitionParser {

    @Override
    public Class<?> getBeanClass(Element element) {
        return User.class;
    }

    @Override
    public void doParse(Element element, ParserContext parserContext, BeanDefinitionBuilder builder) {
        String id = element.getAttribute("id");
        String name = element.getAttribute("name");
        String password = element.getAttribute("password");
        String age = element.getAttribute("age");
        String sex = element.getAttribute("sex");
        builder.addConstructorArgValue(id);
        builder.addConstructorArgValue(name);
        builder.addConstructorArgValue(password);
        builder.addConstructorArgValue(Integer.parseInt(age));
        builder.addConstructorArgValue(Byte.valueOf(sex));
    }
}