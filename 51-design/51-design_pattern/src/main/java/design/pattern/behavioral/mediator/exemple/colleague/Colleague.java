package design.pattern.behavioral.mediator.exemple.colleague;

import design.pattern.behavioral.mediator.exemple.Mediator;

public abstract class Colleague {
	protected Mediator mediator;

	public Colleague(Mediator mediator) {
		this.mediator = mediator;
	}
}
