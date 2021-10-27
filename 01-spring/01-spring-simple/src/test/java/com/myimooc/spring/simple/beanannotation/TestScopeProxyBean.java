package com.myimooc.spring.simple.beanannotation;

import com.myimooc.spring.simple.beanannotation.scoped.proxy.mode.MyBean;
import com.myimooc.spring.simple.beanannotation.scoped.proxy.mode.ScopeProxyBean;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.test.context.junit4.SpringRunner;

import java.net.UnknownHostException;

/**
 * Spring源码之@Scope注解中proxyMode属性理解
 * https://blog.csdn.net/geng2568/article/details/112874664
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = TestScopeProxyBean.class)
public class TestScopeProxyBean {

    //Logger logger = LoggerFactory.getLogger(getClass());

    @Test
    public void test1() throws UnknownHostException {
       AnnotationConfigApplicationContext applicationContext = new AnnotationConfigApplicationContext();
        applicationContext.register(MyBean.class);
        applicationContext.register(ScopeProxyBean.class);
        applicationContext.refresh();
        //MyBean注入了ScopeProxyBean
        MyBean bean = applicationContext.getBean(MyBean.class);
        for (int i = 0; i < 10; i++) {
            bean.test();
        }
    }
 
}
/* @Scope(value = DefaultListableBeanFactory.SCOPE_PROTOTYPE)
1171255580
1171255580
1171255580
1171255580
1171255580
1171255580
1171255580
1171255580
1171255580
1171255580
*///~

/* @Scope(value = DefaultListableBeanFactory.SCOPE_PROTOTYPE, proxyMode = ScopedProxyMode.TARGET_CLASS)
1088239991
61137731
1780293706
1658511941
1264941544
1878992188
1818449913
1495161082
961859592
798278875
*///~