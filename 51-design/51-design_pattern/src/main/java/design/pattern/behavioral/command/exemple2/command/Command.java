package design.pattern.behavioral.command.exemple2.command;

import design.pattern.behavioral.command.exemple2.receiver.DBClient;
import design.pattern.behavioral.command.exemple2.receiver.ElasticSearchClient;
import design.pattern.behavioral.command.exemple2.receiver.RedisClient;

/**
 * 抽象命令类
 *
 * 文章的发布、修改、删除是否都可以看成是一个命令呢？调用者发出一个命令，
 * 接收者去执行，至于命令执行的具体细节，调用者压根就不关心，以此来达到
 * 松散耦合的目的。
 */
public abstract class Command {
	protected DBClient dbClient = new DBClient();
	protected ElasticSearchClient elasticSearchClient = new ElasticSearchClient();
	protected RedisClient redisClient = new RedisClient();

	// 命令的执行，子类实现
	public abstract void execute();
}
