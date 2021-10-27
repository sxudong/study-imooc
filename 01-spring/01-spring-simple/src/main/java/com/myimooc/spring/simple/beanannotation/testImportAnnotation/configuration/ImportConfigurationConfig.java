package com.myimooc.spring.simple.beanannotation.testImportAnnotation.configuration;

import com.myimooc.spring.simple.beanannotation.testImportAnnotation.TestA;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * 单元测试类：com.myimooc.spring.simple.testImportAnnotation.ImportConfigurationTest
 */
@Import({TestA.class,TestB.class})
@Configuration
public class ImportConfigurationConfig {
}
