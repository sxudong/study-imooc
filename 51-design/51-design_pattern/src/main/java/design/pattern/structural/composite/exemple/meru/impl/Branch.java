package design.pattern.structural.composite.exemple.meru.impl;

import design.pattern.structural.composite.exemple.meru.Menu;

import java.util.ArrayList;
import java.util.List;

/**
 * 树枝节点Branch
 */
public class Branch extends Menu {
	private List<Menu> children = new ArrayList<>();

	public Branch(String name, String icon) {
		super(name, icon);
	}

	public void add(Menu menu) {
		children.add(menu);
	}

	public List<Menu> getChildren() {
		return children;
	}
}
