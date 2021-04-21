package design.pattern.reactor;

/**
 * 这个例子没有实现什么具体业务逻辑，只是把reactor模式的框架给实现了，
 * 大家如果要实现基于 reactor模式 的业务功能，可以自己定义InputSource、
 * 定义事件的不同状态、定义事件处理器，目前大家用的比较多的各种NIO框架
 * 就是reactor模式的很好实践。
 *
 * 作者：monkey01
 * 链接：https://www.jianshu.com/p/188ef8462100
 */
public class Server {
    Selector selector = new Selector();
    Dispatcher eventLooper = new Dispatcher(selector);
    Acceptor acceptor;

    Server(int port) {
        acceptor = new Acceptor(selector, port);
    }

    public void start() {
        eventLooper.registEventHandler(EventType.ACCEPT, new AcceptEventHandler(selector));
        new Thread(acceptor, "Acceptor-" + acceptor.getPort()).start();
        eventLooper.handleEvents();
    }
}
