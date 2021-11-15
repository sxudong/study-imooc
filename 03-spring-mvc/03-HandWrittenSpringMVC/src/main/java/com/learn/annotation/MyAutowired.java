package com.learn.annotation;

import java.lang.annotation.*;

/**
 * @Author xumiaofeng
 * @Date 2019/10/25 14:07
 **/

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MyAutowired {
    String value() default "";
}
