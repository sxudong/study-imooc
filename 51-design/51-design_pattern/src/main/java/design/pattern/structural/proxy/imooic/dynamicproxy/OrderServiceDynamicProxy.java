package design.pattern.structural.proxy.imooic.dynamicproxy;

import design.pattern.structural.proxy.imooic.dynamicproxy.order.entity.Order;
import design.pattern.structural.proxy.db.DataSourceContextHolder;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

/**
 * JDK动态代理
 *
 * 实现 InvocationHandler 接口
 */
public class OrderServiceDynamicProxy implements InvocationHandler {

    /**
     * 目标对象，真实的服务对象
     */
    private Object target;

    public OrderServiceDynamicProxy(Object target) {
        this.target = target;
    }

    /**
     * 绑定委托对象并返回一个代理类
     * @return
     */
    public Object bind() {
        Class cls = target.getClass(); // 目标类的class
        // 取得代理对象
        return Proxy.newProxyInstance(cls.getClassLoader(), cls.getInterfaces(),this); // JDK代理需要提供
    }


    /**
     * 通过代理对象调用方法首先进入这个方法
     * @param proxy   代理对象
     * @param method  被调用方法（要被增强的方法对象）
     * @param args    方法的参数
     * @return
     * @throws Throwable
     */
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        // 获取Order对象
        Object argObject = args[0];
        // 反射方法前调用
        beforeMethod(argObject);


        // 执行方法，相当于调用 OrderServiceImpl 的 saveOrder() 方法
        Object object = method.invoke(target, args); // 进入到目标方法saveOrder()


        // 反射方法后调用
        afterMethod();
        return object;
    }

    // 方法前执行
    private void beforeMethod(Object obj){
        int userId = 0;
        System.out.println("动态代理 before code");
        if(obj instanceof Order){
            Order order = (Order) obj;
            userId = order.getUserId();
        }
        int dbRouter = userId % 2;
        System.out.println("动态代理分配到【db"+dbRouter+"】处理数据");

        //todo 设置dataSource;
        DataSourceContextHolder.setDBType("db"+String.valueOf(dbRouter));
    }

    // 方法后执行
    private void afterMethod(){
        System.out.println("动态代理 after code");
    }
}
