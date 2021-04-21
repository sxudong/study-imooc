package design.pattern.behavioral.command.exemple2.command.impl;

import design.pattern.behavioral.command.exemple2.command.Command;

/**
 * 文章发布命令
 */
public class PublishCommand extends Command {

	@Override
	public void execute() {
		super.dbClient.insert();
		super.elasticSearchClient.addDocument();
		super.redisClient.setBitMap();
	}
}
