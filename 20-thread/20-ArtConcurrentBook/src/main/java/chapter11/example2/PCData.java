package chapter11.example2;

/**
 * ���� �������򻺳����ύ������
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