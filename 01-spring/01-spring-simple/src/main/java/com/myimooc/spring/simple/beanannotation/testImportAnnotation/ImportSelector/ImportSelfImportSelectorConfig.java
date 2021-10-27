package com.myimooc.spring.simple.beanannotation.testImportAnnotation.ImportSelector;

import com.myimooc.spring.simple.beanannotation.testImportAnnotation.TestA;
import com.myimooc.spring.simple.beanannotation.testImportAnnotation.configuration.TestB;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Import({TestA.class, TestB.class, SelfImportSelector.class})
@Configuration
public class ImportSelfImportSelectorConfig {
}
