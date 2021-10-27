package com.myimooc.spring.simple.beanannotation.testImportAnnotation;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 *
 * @Configuration 是为了能让Spring扫描到这个类，并且直接通过 @Import 引入TestA类。
 * 单元测试类：com.myimooc.spring.simple.testImportAnnotation.ImportAnnotionTest
 */
@Import({TestA.class})
@Configuration
public class ImportConfig {
}
