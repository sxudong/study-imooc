package com.myimooc.spring.simple.testImportAnnotation;

import com.myimooc.spring.simple.beanannotation.testImportAnnotation.import_bean_definition_registrar.Import_bean_definition_registrar_config;
import com.myimooc.spring.simple.beanannotation.testImportAnnotation.import_bean_definition_registrar.TestD;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @Import注解的作用 —— 通过 ImportBeanDefinitionRegistrar 方式导入的类
 * https://blog.csdn.net/mamamalululu00000000/article/details/86711079
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = Import_bean_definition_registrar_config.class)
public class ImportBeanDefinitionRegistrarTest {

    @Autowired
    TestD testD;

    @Test
    public void TestD() {
        testD.printName();
    }
    /* Output:
    类名 ：com.myimooc.spring.simple.beanannotation.testImportAnnotation.import_bean_definition_registrar.TestD
    *///~
}
