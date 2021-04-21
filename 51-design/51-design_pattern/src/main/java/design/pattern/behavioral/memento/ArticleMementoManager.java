package design.pattern.behavioral.memento;

import java.util.Stack;

/**
 * 备忘录管理类
 *
 * 注意 内存溢出问题，该备份一旦产生就装入内存，没有任何销毁的意向，这是非常危
 * 险的。因此，在系统设计时，要严格限定备忘录的创建，建议增加 Stack 的上限，
 * 否则系统很容易产生内存溢出情况。
 */
public class ArticleMementoManager {
    private final Stack<ArticleMemento> ARTICLE_MEMENTO_STACK = new Stack<>();

    // 拿到最近的快照
    public ArticleMemento getMemento() {
        // 出栈
        ArticleMemento articleMemento = ARTICLE_MEMENTO_STACK.pop();
        return articleMemento;
    }

    public void addMemento(ArticleMemento articleMemento) {
        // 入栈
        ARTICLE_MEMENTO_STACK.push(articleMemento);
    }
}
