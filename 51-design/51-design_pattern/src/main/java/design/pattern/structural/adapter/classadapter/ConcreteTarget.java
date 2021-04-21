package design.pattern.structural.adapter.classadapter;

/**
 * 具体的目标
 */
public class ConcreteTarget implements Target {
    @Override
    public void request() {
        System.out.println("concreteTarget目标方法");
    }
}
