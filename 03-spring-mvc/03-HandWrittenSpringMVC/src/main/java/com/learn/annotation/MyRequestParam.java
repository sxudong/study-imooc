package com.learn.annotation;

import java.lang.annotation.*;

/**
 * @Author xumiaofeng
 * @Date 2019/10/25 14:07
 **/

@Target({ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MyRequestParam {
    String value() default "";
}
