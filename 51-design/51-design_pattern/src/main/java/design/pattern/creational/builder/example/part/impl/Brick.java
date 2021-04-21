package design.pattern.creational.builder.example.part.impl;

import design.pattern.creational.builder.example.part.Part;

public class Brick extends Part {
	public Brick(String specs) {
		super(specs);
	}

	@Override
	public String description() {
		return specs + "砖块";
	}
}