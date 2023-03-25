package chapter13;

/**
 * 《代码整洁之道》P318
 */
public class ClassWithThreadingProblem {
    private int nextId = 1;

    public int takeNextId() {
        return nextId++;
    }

    public int lastId() {
        return nextId;
    }
}
