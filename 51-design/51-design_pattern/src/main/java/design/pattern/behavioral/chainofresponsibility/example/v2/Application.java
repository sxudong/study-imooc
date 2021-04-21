package design.pattern.behavioral.chainofresponsibility.example.v2;

/**
 * 《设计模式之美》62 职责链模式（上）：如何实现可灵活扩展算法的敏感信息过滤框架？
 */
public class Application {
    public static void main(String[] args) {
        HandlerChain chain = new HandlerChain();
        chain.addHandler(new HandlerA());
        chain.addHandler(new HandlerB());
        chain.handle();
    }
}
/* Output:
执行 HandlerA
执行 HandlerB
*///~