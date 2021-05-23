package chapter04;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.util.concurrent.TimeUnit;

/**
 * 代码清单 4-17
 * 4.4.2 一个简单的数据库连接池示例
 *
 * 由于java.sql.Connection是一个接口，最终的实现是由数据库驱动提供方来实现的，考虑到
 * 只是个示例，我们通过动态代理构造了一个Connection，该Connection的代理实现仅仅是在
 * commit()方法调用时休眠100毫秒。
 */
public class ConnectionDriver {
    static class ConnectionHandler implements InvocationHandler { //动态代理
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            //Object object = method.invoke(target, args);
            //commit()方法调用时休眠100毫秒
            if (method.getName().equals("commit")) {
                TimeUnit.MILLISECONDS.sleep(100);
            }
            return null;
        }
    }

    // 创建一个Connection的代理，在commit时休眠1秒
    public static final Connection createConnection() {
        return (Connection) Proxy.newProxyInstance(ConnectionDriver.class.getClassLoader(), //真实服务对象的类加载器
                new Class<?>[] { Connection.class }, //代理对象挂在哪个接口下
                new ConnectionHandler());
    }
}
