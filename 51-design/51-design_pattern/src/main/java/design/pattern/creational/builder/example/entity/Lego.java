package design.pattern.creational.builder.example.entity;

import design.pattern.creational.builder.example.part.impl.Brick;
import design.pattern.creational.builder.example.part.impl.Gear;
import design.pattern.creational.builder.example.part.Part;
import design.pattern.creational.builder.example.part.impl.Plate;
import design.pattern.creational.builder.example.part.impl.Tile;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

/**
 * 定义乐高套件，它由四种零件组成：
 */
@Getter
public class Lego {
	private List<Brick> bricks = new ArrayList<>();
	private List<Plate> plates = new ArrayList<>();
	private List<Tile> tiles = new ArrayList<>();
	private List<Gear> gears = new ArrayList<>();

	public Lego(){}

	// 展示套件
	public void show() {
		print(bricks);
		print(plates);
		print(tiles);
		print(gears);
	}

	private void print(List<? extends Part> parts) {
		if (!parts.isEmpty()) {
			System.out.println("(" + parts.get(0).description() + ")" + " x " + parts.size());
		}
	}
}