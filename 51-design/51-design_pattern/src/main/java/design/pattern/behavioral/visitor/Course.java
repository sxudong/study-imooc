package design.pattern.behavioral.visitor;

public abstract class Course {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // 允许一个访问者的访问，是否接受它的访问
    public abstract void accept(IVisitor visitor);
}
