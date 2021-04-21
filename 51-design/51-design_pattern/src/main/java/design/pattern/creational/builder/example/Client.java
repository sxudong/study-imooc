package design.pattern.creational.builder.example;

import design.pattern.creational.builder.example.entity.Lego;

/**
 * 建造者模式-万能的乐高
 * https://javap.blog.csdn.net/article/details/111880091
 * 需求：构建乐高积木
 * 乐高的积木套装就是将不同规格的零件组合在一起，最终可以拼成一个成品如城堡、汽车等。
 */
public class Client {
	public static void main(String[] args) {
		Director director = new Director();
		Lego simpleLego = director.createSimple();
		System.out.println("简易乐高套件:");
		simpleLego.show();

		Lego complexLego = director.createComplex();
		System.out.println("复杂乐高套件:");
		complexLego.show();
	}
}
/*
简易乐高套件:
(2x2砖块) x 10
(3x3底板) x 5
(4x4瓦片) x 15
(1x1齿轮) x 20
复杂乐高套件:
(2x2砖块) x 100
(3x3底板) x 50
(4x4瓦片) x 150
(1x1齿轮) x 200
*/