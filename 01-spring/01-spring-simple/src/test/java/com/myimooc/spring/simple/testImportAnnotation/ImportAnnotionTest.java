package com.myimooc.spring.simple.testImportAnnotation;

import com.myimooc.spring.simple.beanannotation.testImportAnnotation.ImportConfig;
import com.myimooc.spring.simple.beanannotation.testImportAnnotation.TestA;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


/**
 * @Import注解的作用 —— 导入普通类
 * https://blog.csdn.net/mamamalululu00000000/article/details/86711079
 *
 * TestA 是一个普通的类，现在可以被 @Autowired 注释然后调用，
 * 就直接说明已经被 Spring 注入并管理了，普通的类都是需要先实例化。
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = ImportConfig.class)
public class ImportAnnotionTest {

    @Autowired
    TestA testA;

    @Test
    public void TestA() {
        testA.printName();
    } /* Output:
    类名 ：com.myimooc.spring.simple.beanannotation.testImportAnnotation.TestA
    *///~

}
