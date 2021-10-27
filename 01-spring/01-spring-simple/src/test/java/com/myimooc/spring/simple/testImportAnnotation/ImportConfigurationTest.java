package com.myimooc.spring.simple.testImportAnnotation;

import com.myimooc.spring.simple.beanannotation.testImportAnnotation.configuration.ImportConfigurationConfig;
import com.myimooc.spring.simple.beanannotation.testImportAnnotation.configuration.TestB;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;


/**
 * @Import注解的作用 —— 导入带有 @Configuration 的配置类
 * https://blog.csdn.net/mamamalululu00000000/article/details/86711079
 *
 * TestB.class 的类上面已经有了@Configuration注解,本身就会配spring扫到并实例，
 * @import 引入带有@Configuration的配置文件，是需要先实例这个配置文件再进行相关操作。
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = ImportConfigurationConfig.class)
public class ImportConfigurationTest {

    @Autowired
    TestB testB;

    @Test
    public void TestB() {
        testB.printName();
    } /* Output:
    类名 ：com.myimooc.spring.simple.beanannotation.testImportAnnotation.config.TestB
    *///~

}
