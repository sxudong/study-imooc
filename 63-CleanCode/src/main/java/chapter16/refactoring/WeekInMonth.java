package chapter16.refactoring;

public enum WeekInMonth { // 代码清单 B-11 (最终版本) P381
    FIRST(1), SECOND(2), THIRD(3), FOURTH(4), LAST(0);
    private final int index;

    WeekInMonth(int index) {
        this.index = index;
    }

    public int toInt() {
        return index;
    }
}
