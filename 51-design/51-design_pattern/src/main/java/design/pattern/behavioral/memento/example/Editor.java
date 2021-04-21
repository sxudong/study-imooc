package design.pattern.behavioral.memento.example;

/**
 * 编辑器软件，可以编辑标题和内容，而且可以展示文档，代码很简单如下:
 * 支持创建备忘录对象和从备忘录中恢复数据
 */
public class Editor {
	private String title;//标题
	private String content;//内容
	
	public void setTitle(String title) {
		this.title = title;
	}

	public void setContent(String content) {
		this.content = content;
	}

	// 展示
	public void show() {
		System.out.println("{title='" + title +"', content='" + content +"'}");
	}

	// 创建备忘录对象
	public Memento createMemento(){
		return new Memento(title, content);
	}

	// 从备忘录中恢复数据
	public void restoreMemento(Memento memento) {
		if (memento != null) {
			this.title = memento.getTitle();
			this.content = memento.getContent();
		}
	}
}
