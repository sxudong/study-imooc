package design.pattern.behavioral.memento;

/**
 * 22-2 备忘录模式
 * 注意 内存溢出问题，该备份一旦产生就装入内存，没有任何销毁的意向，这是非常危
 * 险的。因此，在系统设计时，要严格限定备忘录的创建，建议增加 Stack 的上限，
 * 否则系统很容易产生内存溢出情况。
 *
 * spring-webflow 工作流
 */
public class Test {
    public static void main(String[] args) {
        // 备忘录管理者
        ArticleMementoManager articleMementoManager = new ArticleMementoManager();
        // 手机
        Article article = new Article("如影随行的设计模式","手记内容A","手记图片A");
        // 备忘录
        ArticleMemento articleMemento = article.saveToMemento();

        // 存档 1
        articleMementoManager.addMemento(articleMemento);
        System.out.println("标题：" + article.getTitle()
                + " 内容：" + article.getContent()
                + " 图片：" + article.getImgs()
                + " 暂存成功");

        System.out.println("手记完整信息：" + article);

        System.out.println("修改手机start");

        article.setTitle("如影随行的设计模式B");
        article.setContent("手记内容B");
        article.setImgs("手记图片B");

        System.out.println("修改手机end");
        System.out.println("手记完整信息：" + article);

        // 存档 2
        articleMemento = article.saveToMemento();
        articleMementoManager.addMemento(articleMemento);

        article.setTitle("如影随行的设计模式C");
        article.setContent("手记内容C");
        article.setImgs("手机图片C");

        System.out.println("暂停回退start");

        // 回退出栈 1 次
        System.out.println("回退出栈1次");
        articleMemento = articleMementoManager.getMemento();
        article.undoFromMemento(articleMemento);

        // 回退出栈 2 次
        System.out.println("回退出栈2次");
        articleMemento = articleMementoManager.getMemento();
        article.undoFromMemento(articleMemento);

        System.out.println("暂存回退end");
        System.out.println("手记完整信息：" + article);
    }
}
/* Output:
标题：如影随行的设计模式 内容：手记内容A 图片：手记图片A 暂存成功
手记完整信息：Article{title='如影随行的设计模式', content='手记内容A', imgs='手记图片A'}
修改手机start
修改手机end
手记完整信息：Article{title='如影随行的设计模式B', content='手记内容B', imgs='手记图片B'}
暂停回退start
回退出栈1次
回退出栈2次
暂存回退end
手记完整信息：Article{title='如影随行的设计模式', content='手记内容A', imgs='手记图片A'}
*///~