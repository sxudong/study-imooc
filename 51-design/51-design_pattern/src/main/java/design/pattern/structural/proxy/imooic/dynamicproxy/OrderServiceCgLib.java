package design.pattern.structural.proxy.imooic.dynamicproxy;

import design.pattern.structural.proxy.imooic.dynamicproxy.order.entity.Order;
import design.pattern.structural.proxy.db.DataSourceContextHolder;
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

import java.lang.reflect.Method;

/**
 * CGLIB动态代理
 */
public class OrderServiceCgLib implements MethodInterceptor {

    private Object target;

    /**
     * 创建代理对象
     * @param target
     * @return
     */
    public Object getInstance(Object target) {
        this.target = target;
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(this.target.getClass());
        // 回调方法
        enhancer.setCallback(this);
        // 创建代理对象
        return enhancer.create();
    }

    /**
     * 回调方法
     */
    @Override
    public Object intercept(Object obj, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
        Object result;
        // 获取Order对象
        Object argObject = objects[0];
        beforeMethod(argObject); // 反射方法前调用.


        // 执行方法,相当于调用 HelloServiceImpl 类的 sayHello方法.
        result = methodProxy.invokeSuper(obj, objects);


        afterMethod(); // 反射方法后调用.
        return result;
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
