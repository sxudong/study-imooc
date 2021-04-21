package design.pattern.creational.builder.example.part;

// 零件抽象基类
public abstract class Part {
	protected String specs;//规格

	public Part(String specs) {
		this.specs = specs;
	}

	public abstract String description();
}