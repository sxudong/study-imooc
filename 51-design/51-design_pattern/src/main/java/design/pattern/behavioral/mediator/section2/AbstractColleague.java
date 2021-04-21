package design.pattern.behavioral.mediator.section2;

/**
 * 同事的抽象类
 */
public abstract class AbstractColleague {
	protected AbstractMediator mediator;
	public AbstractColleague(AbstractMediator _mediator){
		this.mediator = _mediator;
	}
}
