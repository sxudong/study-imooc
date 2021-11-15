package com.learn.annotation;

import java.lang.annotation.*;

/**
 * @Author xumiaofeng
 * @Date 2019/10/25 14:08
 **/
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MyService {
    String value() default "";
}
