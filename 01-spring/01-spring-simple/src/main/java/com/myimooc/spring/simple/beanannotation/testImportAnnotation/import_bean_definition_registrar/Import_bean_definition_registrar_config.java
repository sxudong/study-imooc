package com.myimooc.spring.simple.beanannotation.testImportAnnotation.import_bean_definition_registrar;

import com.myimooc.spring.simple.beanannotation.testImportAnnotation.ImportSelector.SelfImportSelector;
import com.myimooc.spring.simple.beanannotation.testImportAnnotation.TestA;
import com.myimooc.spring.simple.beanannotation.testImportAnnotation.configuration.TestB;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * @Import注解的作用 —— 通过 ImportBeanDefinitionRegistrar 方式导入的类
 * https://blog.csdn.net/mamamalululu00000000/article/details/86711079
 *
 * 单元测试类：com.myimooc.spring.simple.testImportAnnotation.Import_bean_definition_registrar_config
 */
@Import({TestA.class, TestB.class, SelfImportSelector.class,
        SelfImportBeanDefinitionRegistrar.class})
@Configuration
public class Import_bean_definition_registrar_config {
}
