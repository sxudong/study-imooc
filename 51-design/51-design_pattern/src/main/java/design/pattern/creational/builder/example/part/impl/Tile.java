package design.pattern.creational.builder.example.part.impl;

import design.pattern.creational.builder.example.part.Part;

public class Tile extends Part {
	public Tile(String specs) {
		super(specs);
	}

	@Override
	public String description() {
		return specs + "瓦片";
	}
}