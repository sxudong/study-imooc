package com.SpringSource.ch07.aop.cglib;

import org.springframework.cglib.proxy.Enhancer;
import org.springframework.cglib.proxy.MethodInterceptor;
import org.springframework.cglib.proxy.MethodProxy;

import java.lang.reflect.Method;

/**
 * CGLIB使用示例
 * 《Spring源码深入解析》P196
 */
public class EnhancerDemo {
	public static void main(String[] args) {
		Enhancer enhancer = new Enhancer();
		enhancer.setSuperclass(EnhancerDemo.class);
		enhancer.setCallback(new MethodInterceptorImpl());
		EnhancerDemo demo = (EnhancerDemo) enhancer.create();
		demo.test();
		System.out.println(demo);
	}

	public void test(){
		System.out.println("EnhancerDemo test()");
	}

	private static class MethodInterceptorImpl implements MethodInterceptor {
		@Override
		public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy) throws Throwable {
			System.out.println("Before invoke " + method);
			Object result = proxy.invokeSuper(obj, args);
			System.out.println("After invoke " + method);
			return result;
		}
	}
}
/* Output:
Before invoke public void com.gqzdev.aop.proxy.cglib.EnhancerDemo.test()
EnhancerDemo test()
After invoke public void com.gqzdev.aop.proxy.cglib.EnhancerDemo.test()
Before invoke public java.lang.String java.lang.Object.toString()
Before invoke public native int java.lang.Object.hashCode()
After invoke public native int java.lang.Object.hashCode()
After invoke public java.lang.String java.lang.Object.toString()
com.gqzdev.aop.proxy.cglib.EnhancerDemo$$EnhancerByCGLIB$$34a390e7@15327b79
*///~