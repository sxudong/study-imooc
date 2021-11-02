package com.myimooc.spring.simple.beanannotation.testImportAnnotation.import_bean_definition_registrar;

import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.context.annotation.ImportBeanDefinitionRegistrar;
import org.springframework.core.type.AnnotationMetadata;

/**
 * @Import注解的作用 —— 通过 ImportBeanDefinitionRegistrar 方式导入的类
 * https://blog.csdn.net/mamamalululu00000000/article/details/86711079
 * (参见 study-imooc/61-spring-annotation 有相同例子)
 */
public class SelfImportBeanDefinitionRegistrar implements ImportBeanDefinitionRegistrar {
    @Override
    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        RootBeanDefinition root = new RootBeanDefinition(TestD.class);
        registry.registerBeanDefinition("testD", root);
    }
}
