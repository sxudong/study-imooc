package design.pattern.creational.builder.example.part.impl;

import design.pattern.creational.builder.example.part.Part;

public class Gear extends Part {
	public Gear(String specs) {
		super(specs);
	}

	@Override
	public String description() {
		return specs + "齿轮";
	}
}