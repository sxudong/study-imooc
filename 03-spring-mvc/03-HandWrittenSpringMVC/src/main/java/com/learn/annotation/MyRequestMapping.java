package com.learn.annotation;

import java.lang.annotation.*;

/**
 * @Author xumiaofeng
 * @Date 2019/10/25 14:06
 **/
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MyRequestMapping {
    String value() default "";
}
