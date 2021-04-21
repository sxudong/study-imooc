package design.pattern.structural.composite.exemple.meru.impl;

import design.pattern.structural.composite.exemple.meru.Menu;

/**
 * 树叶节点Leaf
 */
public class Leaf extends Menu {
	private String url;

	public Leaf(String name, String icon, String url) {
		super(name, icon);
		this.url = url;
	}

	@Override
	public void print() {
		System.out.println("name:" + name + ",icon:" + icon + ",url:" + url);
	}
}
