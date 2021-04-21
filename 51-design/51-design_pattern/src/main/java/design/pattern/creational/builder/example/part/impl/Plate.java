package design.pattern.creational.builder.example.part.impl;

import design.pattern.creational.builder.example.part.Part;

public class Plate extends Part {
	public Plate(String specs) {
		super(specs);
	}

	@Override
	public String description() {
		return specs + "底板";
	}
}