package design.pattern.structural.composite.exemple;

import design.pattern.structural.composite.exemple.meru.Menu;
import design.pattern.structural.composite.exemple.meru.impl.Branch;
import design.pattern.structural.composite.exemple.meru.impl.Leaf;

/**
 * 组合模式-系统菜单的设计
 * https://javap.blog.csdn.net/article/details/112385024
 * 典型的设计就是一个「树状结构」，数据库表用一个parent_id来构建整棵菜单树。
 * 菜单分为两类：菜单目录和具备URL地址可点击的菜单，即树枝节点和树叶节点。
 * 分别设计Branch类代表“菜单目录”，Leaf类代表“菜单”。
 */
public class Client {
	public static void main(String[] args) {
		Branch root = new Branch("系统管理", "system.icon");
		Branch menu = new Branch("菜单管理", "menu.icon");
		menu.add(new Leaf("菜单列表", "menuList.icon", "/menu/list.html"));
		menu.add(new Leaf("用户菜单", "userMenu.icon", "/menu/user.html"));
		root.add(menu);
		root.add(new Leaf("角色管理", "role.icon", "/role.html"));
		root.add(new Leaf("权限管理", "auth.icon", "/auth.html"));

		show(root, 0);
	}

	static void show(Menu menu, int tier) {
		for (int i = 0; i < tier; i++) {
			System.out.print("····");
		}
		if (menu instanceof Branch) {
			menu.print();
			for (Menu child : ((Branch) menu).getChildren()) {
				show(child, tier + 1);
			}
		} else if (menu instanceof Leaf) {
			menu.print();
		}
	}
}
/*
name:系统管理,icon:system.icon
····name:菜单管理,icon:menu.icon
········name:菜单列表,icon:menuList.icon,url:/menu/list.html
········name:用户菜单,icon:userMenu.icon,url:/menu/user.html
····name:角色管理,icon:role.icon,url:/role.html
····name:权限管理,icon:auth.icon,url:/auth.html
 */