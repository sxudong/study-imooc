package design.pattern.behavioral.command.exemple2.command.impl;

import design.pattern.behavioral.command.exemple2.command.Command;

/**
 * 文章修改命令
 *
 * 如果用户要修改文章呢？也非常简单，只需要再扩展一个修改命令即可。
 */
public class UpdateCommand extends Command {

	@Override
	public void execute() {
		// 更新数据库
		super.dbClient.update();
		// 更新索引
		super.elasticSearchClient.updateDocument();
		// 修改文章，文章ID不变，位图不用动。
	}
}
