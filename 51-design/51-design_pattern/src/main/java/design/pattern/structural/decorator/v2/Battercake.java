package design.pattern.structural.decorator.v2;

/**
 * 实体煎饼（具体的组件）
 * 该角色实现了Component角色组件所定义的接口（API）
 */
public class Battercake extends ABattercake {
    @Override
    protected String getDesc() {
        return "煎饼";
    }

    @Override
    protected int cost() {
        return 8;
    }
}
