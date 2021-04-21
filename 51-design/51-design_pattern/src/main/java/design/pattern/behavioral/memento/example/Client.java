package design.pattern.behavioral.memento.example;

/**
 * 备忘录模式-程序数据的“后悔药”
 * https://javap.blog.csdn.net/article/details/112427101
 * 备忘录模式很常用，例如：文档的撤销、数据库的事务等都可以使用备忘录模式来实现。
 * 场景：编辑器的撤销功能
 */
public class Client {
	public static void main(String[] args) {
		Caretaker caretaker = new Caretaker();
		Editor editor = new Editor();
		editor.setTitle("标题v1.0");
		editor.setContent("内容v1.0");
		caretaker.save(editor.createMemento());//保存
		editor.show();

		editor.setTitle("标题v2.0");
		editor.setContent("内容v2.0");
		caretaker.save(editor.createMemento());//保存
		editor.show();

		editor.setTitle("标题写错了");
		editor.setTitle("内容写错了");
		editor.restoreMemento(caretaker.restore());
		editor.show();
		//再撤销，恢复到原始数据
		editor.restoreMemento(caretaker.restore());
		editor.show();
	}
}
/*
{title='标题v1.0', content='内容v1.0'}
{title='标题v2.0', content='内容v2.0'}
{title='标题v2.0', content='内容v2.0'}
{title='标题v1.0', content='内容v1.0'}
 */