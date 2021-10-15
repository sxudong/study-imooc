package com.atguigu;

import java.lang.reflect.Field;
  
import org.springframework.aop.framework.AdvisedSupport;  
import org.springframework.aop.framework.AopProxy;  
import org.springframework.aop.support.AopUtils;


/**
 * 在 spring 中获取代理对象代理的目标对象工具类
 */
public class AopTargetUtils {  
  
      
    /** 
     * 获取 目标对象 
     * @param proxy 代理对象 
     * @return  
     * @throws Exception 
     */  
    public static Object getTarget(Object proxy) throws Exception {  
          
        if(!AopUtils.isAopProxy(proxy)) {
            //System.out.println("不是代理对象 ");
            return proxy;//不是代理对象  
        }  
          
        if(AopUtils.isJdkDynamicProxy(proxy)) {  
            return getJdkDynamicProxyTargetObject(proxy);  
        } else { //cglib  
            return getCglibProxyTargetObject(proxy);  
        }
    }  
  
  
    private static Object getCglibProxyTargetObject(Object proxy) throws Exception {
        // Field h = proxy.getClass().getDeclaredField("CGLIB$CALLBACK_6"); 也可以
        Field h = proxy.getClass().getDeclaredField("CGLIB$CALLBACK_0");
        h.setAccessible(true);  
        Object dynamicAdvisedInterceptor = h.get(proxy);  
          
        Field advised = dynamicAdvisedInterceptor.getClass().getDeclaredField("advised");  
        advised.setAccessible(true);  
          
        Object target = ((AdvisedSupport)advised.get(dynamicAdvisedInterceptor)).getTargetSource().getTarget();
        //System.out.println("Cglib代理对象");
        return target;  
    }  
  
  
    private static Object getJdkDynamicProxyTargetObject(Object proxy) throws Exception {  
        Field h = proxy.getClass().getSuperclass().getDeclaredField("h");  
        h.setAccessible(true);  
        AopProxy aopProxy = (AopProxy) h.get(proxy);  
          
        Field advised = aopProxy.getClass().getDeclaredField("advised");  
        advised.setAccessible(true);  
          
        Object target = ((AdvisedSupport)advised.get(aopProxy)).getTargetSource().getTarget();
        //System.out.println("JDK代理对象");
        return target;  
    }  
      
}  