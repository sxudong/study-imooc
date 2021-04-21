package design.pattern.structural.decorator.v2;

/**
 * 抽象煎饼（组件）
 * 增加功能时的核心角色。装饰前的组件。组件角色只是定义了接口（API）。
 */
public abstract class ABattercake {
    protected abstract String getDesc();
    protected abstract int cost();
}
