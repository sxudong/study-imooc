package com.myimooc.spring.simple.beanannotation.testImportAnnotation.ImportSelector;

import org.springframework.context.annotation.ImportSelector;
import org.springframework.core.type.AnnotationMetadata;

public class SelfImportSelector implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        return new String[]{"com.myimooc.spring.simple.beanannotation.testImportAnnotation.ImportSelector.TestC"};
    }
}
