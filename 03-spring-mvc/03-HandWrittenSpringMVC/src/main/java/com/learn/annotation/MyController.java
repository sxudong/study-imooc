package com.learn.annotation;

import java.lang.annotation.*;

/**
 * @Author xumiaofeng
 * @Date 2019/10/25 14:05
 **/
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MyController {
    String value() default "";
}
