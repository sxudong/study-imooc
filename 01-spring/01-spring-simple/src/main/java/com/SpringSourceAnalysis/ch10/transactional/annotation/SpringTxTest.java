package com.SpringSourceAnalysis.ch10.transactional.annotation;

import org.junit.Test;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class SpringTxTest {
    @Test
    public void testInsert(){
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(SpringTxConfig.class);
        UserService service = context.getBean(UserService.class);
        service.insertUser();
    }
}