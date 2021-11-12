package com.SpringSourceAnalysis.tx;


import com.SpringSourceAnalysis.ch10.transactional.annotation.SpringTxConfig;
import com.SpringSourceAnalysis.ch10.transactional.annotation.UserService ;
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

