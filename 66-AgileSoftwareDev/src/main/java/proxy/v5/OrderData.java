package proxy.v5;

public class OrderData {
    public String customerId;
    public int orderId;

    public OrderData() {
    }

    public OrderData(int orderId,  String customerId) {
        this.orderId = orderId;
        this.customerId = customerId;
    }
}
