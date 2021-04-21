package design.pattern.behavioral.mediator.section3;

/**
 * 设计模式之禅
 *
 * 同事类
 */
public abstract class Colleague {
	protected Mediator mediator;
	public Colleague(Mediator _mediator){
		this.mediator = _mediator;
	}
}
