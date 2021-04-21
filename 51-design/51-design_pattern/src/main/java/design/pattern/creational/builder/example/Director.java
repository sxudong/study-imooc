package design.pattern.creational.builder.example;

import design.pattern.creational.builder.example.builder.impl.ComplexBuilder;
import design.pattern.creational.builder.example.builder.impl.SimpleBuilder;
import design.pattern.creational.builder.example.entity.Lego;

/**
 * 为了避免高层模块深入到构建者内部的实现类，因此创建一个导演类，
 * 由导演类来复杂调用构建器生成套件实例。
 */
public class Director {
	public Lego createSimple(){
		return new SimpleBuilder()
				.buildBrick()
				.buildPlate()
				.buildTile()
				.buildGear()
				.build();
	}

	public Lego createComplex(){
		return new ComplexBuilder()
				.buildBrick()
				.buildPlate()
				.buildTile()
				.buildGear()
				.build();
	}
}
