package com.myimooc.spring.simple.testImportAnnotation;

import com.myimooc.spring.simple.beanannotation.testImportAnnotation.ImportSelector.ImportSelfImportSelectorConfig;
import com.myimooc.spring.simple.beanannotation.testImportAnnotation.ImportSelector.TestC;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @Import注解的作用 —— 通过 ImportSelector 方式导入的类
 * https://blog.csdn.net/mamamalululu00000000/article/details/86711079
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = ImportSelfImportSelectorConfig.class)
public class ImportSelfImportSelectorTest {

    @Autowired
    TestC testC;

    @Test
    public void TestC() {
        testC.printName();
    }
    /* Output:
    类名 ：com.myimooc.spring.simple.beanannotation.testImportAnnotation.ImportSelector.TestC
    *///~
}
