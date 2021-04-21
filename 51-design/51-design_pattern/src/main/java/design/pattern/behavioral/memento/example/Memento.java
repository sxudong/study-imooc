package design.pattern.behavioral.memento.example;

/**
 * 备忘录类
 */
public class Memento {
	// 备忘录一经创建，就不能修改
	private final String title;
	private final String content;

	public Memento(String title, String content) {
		this.title = title;
		this.content = content;
	}

	public String getTitle() {
		return title;
	}

	public String getContent() {
		return content;
	}
}
