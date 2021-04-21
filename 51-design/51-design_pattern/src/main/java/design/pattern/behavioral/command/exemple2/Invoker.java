package design.pattern.behavioral.command.exemple2;

import design.pattern.behavioral.command.exemple2.command.Command;

/**
 * 命令执行者
 *
 * 客户端的调用变得非常的简单，客户端只需要创建指定的命令，
 * 交给Invoker执行就OK了，至于命令执行的细节它是不关心的。
 */
public class Invoker {
	private Command command;

	// 设置命令
	public void setCommand(Command command) {
		this.command = command;
	}

	// 执行命令
	public void action(){
		this.command.execute();
	}
}
