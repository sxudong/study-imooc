package proxy.v1;

/**
 * 程序26.2 向关系数据库中增加一个条目 P287
 * 这段代码，糟糕的是，使得程序去关注SQL语句、数据库连接以及拼凑在一起的查询字段串。
 * 严重违反了SRP，并且还可能违反CCP。程序26.2把两个具有不同更改原因的概念混合在一起。
 * 它把商品条目和订单的概念与关系模式（schema） 和  SQL的概念混合在一起。无论任何原因
 * 造成其中一个概念需要更改，另一个概念就会受到影响。程序26.2也违反了DIP，因为程序的策略
 * 依赖于存储机制的细节。
 * PROXY模式是解决这些问题的一种方法。
 */
//public class AddItemTransaction extends Transaction {
//    public void addItem(int orderId, String sku, int qty) {
//        Statement s = itsConnection.CreateStatement();
//        s.executeUpdate("insert into items values(" + orderId + "," + sku + ", " + qty + ")");
//    }
//}
