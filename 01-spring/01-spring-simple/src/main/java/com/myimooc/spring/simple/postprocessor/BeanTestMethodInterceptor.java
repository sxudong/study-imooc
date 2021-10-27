package com.myimooc.spring.simple.postprocessor;

import org.springframework.cglib.proxy.MethodInterceptor;
import org.springframework.cglib.proxy.MethodProxy;

import java.lang.reflect.Method;

/**
 * CGLIB的方法拦截器，继续于Callback
 */
public class BeanTestMethodInterceptor implements MethodInterceptor {

    @Override
    public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
        if(method.getName().equalsIgnoreCase("getName")){
            System.out.println("调用 getName 方法 ");
        }else if(method.getName().equalsIgnoreCase("setName")){
            objects = new Object[]{"被替换掉啦"};
        }

        Object object = methodProxy.invokeSuper(o, objects);
        return object;
    }
}
