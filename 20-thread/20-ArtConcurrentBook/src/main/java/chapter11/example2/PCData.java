package chapter11.example2;

/**
 * 任务 生产者向缓冲区提交的数据
 */
public final class PCData {
    private final int intData;

    public PCData(int d) {
        this.intData = d;
    }

    public int getData() {
        return intData;
    }

    @Override
    public String toString() {
        return "data: " + intData;
    }
}