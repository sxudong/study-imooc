package design.pattern.behavioral.command.exemple2.receiver;

public class ElasticSearchClient {

	public void addDocument(){
		System.out.println("ElasticSearch建立文章索引...");
	}

	public void updateDocument(){
		System.out.println("ElasticSearch更新文章索引...");
	}

	public void deleteDocument(){
		System.out.println("ElasticSearch删除文章索引...");
	}
}
