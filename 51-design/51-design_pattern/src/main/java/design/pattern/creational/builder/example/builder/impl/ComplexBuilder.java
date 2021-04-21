package design.pattern.creational.builder.example.builder.impl;

import design.pattern.creational.builder.example.entity.Lego;
import design.pattern.creational.builder.example.builder.Builder;
import design.pattern.creational.builder.example.part.impl.Brick;
import design.pattern.creational.builder.example.part.impl.Gear;
import design.pattern.creational.builder.example.part.impl.Plate;
import design.pattern.creational.builder.example.part.impl.Tile;

// 困难套件
public class ComplexBuilder implements Builder {
	private Lego lego = new Lego();

	@Override
	public Builder buildBrick() {
		for (int i = 0; i < 100; i++) {
			lego.getBricks().add(new Brick("2x2"));
		}
		return this;
	}

	@Override
	public Builder buildPlate() {
		for (int i = 0; i < 50; i++) {
			lego.getPlates().add(new Plate("3x3"));
		}
		return this;
	}

	@Override
	public Builder buildTile() {
		for (int i = 0; i < 150; i++) {
			lego.getTiles().add(new Tile("4x4"));
		}
		return this;
	}

	@Override
	public Builder buildGear() {
		for (int i = 0; i < 200; i++) {
			lego.getGears().add(new Gear("1x1"));
		}
		return this;
	}

	@Override
	public Lego build() {
		return this.lego;
	}
}