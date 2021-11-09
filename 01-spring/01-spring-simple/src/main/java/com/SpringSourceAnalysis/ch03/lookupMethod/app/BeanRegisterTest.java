package com.SpringSourceAnalysis.ch03.lookupMethod.app;

import org.springframework.beans.factory.xml.DefaultBeanDefinitionDocumentReader;
import org.w3c.dom.Element;

/**
 * 4.解析子元素 lookup-method
 * 《Spring源码深度解析》P44
 */
public class BeanRegisterTest extends DefaultBeanDefinitionDocumentReader {

    @Override
    protected void preProcessXml(Element root) {
        System.out.println("preProcessXml");
    }

    @Override
    protected void postProcessXml(Element root) {
        System.out.println("postProcessXml");
    }
}
