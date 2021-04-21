package design.pattern.structural.composite.exemple.meru;

public abstract class Menu {
	protected String name;
	protected String icon;

	public Menu(String name, String icon) {
		this.name = name;
		this.icon = icon;
	}

	public void print(){
		System.out.println("name:" + name + ",icon:" + icon);
	}
}
