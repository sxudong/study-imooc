package proxy.v5;

import java.sql.*;
import java.util.LinkedList;


/**
 * 程序26.9 P291
 */
public class DB {
    private static Connection con;
    // 数据库驱动
    public static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    // 数据库连接地址
    public static final String DB_URL = "jdbc:mysql://localhost:3306/orcl?serverTimezone=UTC";

    // 数据库用户名称
    public static final String DB_USER = "root";

    // 数据库用户密码
    public static final String DB_PASSWORD = "root";

    public static void init() throws Exception {
        //Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
        //con = DriverManager.getConnection("jdbc:odbc:PPP Shopping Cart");

        // 加载数据库驱动类
        Class.forName(DRIVER_CLASS);
        System.out.println("数据库驱动加载成功");

        // 获取数据库连接对象
        con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        System.out.println("数据库连接成功");
    }

    public static void store(ProductData pd) throws Exception {
        PreparedStatement s = buildProductInsertionStatement(pd);
        executeStatement(s);
    }

    private static PreparedStatement buildProductInsertionStatement(ProductData pd) throws Exception {
        PreparedStatement s = con.prepareStatement("INSERT INTO Products VALUES (?, ?, ?)");
        s.setString(1, pd.sku);
        s.setString(2, pd.name);
        s.setInt(3,pd.price);
        return s;
    }

    public static ProductData getProductData(String sku) throws Exception {
        PreparedStatement s = buildProductInsertionStatement(sku);
        ResultSet rs = s.executeQuery();
        ProductData pd = extractProductDataFromResultSet(rs);
        rs.close();
        s.close();
        return pd;
    }

    private static PreparedStatement buildProductInsertionStatement(String sku) throws SQLException {
        PreparedStatement s = con.prepareStatement("SELECT * FROM Products WHERE sku = ?;");
        s.setString(1, sku);
        return s;
    }

    private static ProductData extractProductDataFromResultSet(ResultSet rs) throws SQLException {
        ProductData pd = new ProductData();
        while(rs.next()){
            pd.sku = rs.getString(1);
            pd.name = rs.getString(2);
            pd.price = rs.getInt(3);
        }
        return pd;
    }




    public static void deleteProductData(String sku) throws Exception {
        executeStatement(buildProductDeleteStatement(sku));
    }

    private static PreparedStatement buildProductDeleteStatement(String sku) throws SQLException {
        PreparedStatement s = con.prepareStatement("DELETE FROM Products WHERE sku = ?");
        s.setString(1, sku);
        return s;
    }

    private static void executeStatement(PreparedStatement s) throws Exception {
        s.execute();
        s.close();
    }

    private static ResultSet executeQueryStatement(PreparedStatement s) throws SQLException {
        ResultSet rs = s.executeQuery();
        rs.next();
        return rs;
    }

    public static void close() throws Exception {
        con.close();
    }

    /**
     * 程序26.17 P297
     *
     * 现在我们需要编写 DB 的 newOrder 方法。请注意，我们在程序 26.14 中调用它时，
     * 给它提供了拥有它的客户的ID，却没有提供 orderId 。每个 Order 都需要一个 orderId
     * 来充当安的键值。此外，在关系模式中，每个 Item 都引用到该 orderId 来表明它和 Order
     * 之间的联系。显然，orderId 必须是唯一的。如何产生它呢？我们编写一个测试来展示我们的意思。
     */
    public static OrderData newOrder(String customerId) throws Exception {
        // 每创建一个新 Order 时，orderId都会以某种方式自动加 1。
        // 只要查询数据库获得当前正在使用的 orderId 的最大值，并在其上加 1 即可。
        int newMaxOrder1 = getMaxOrderId() + 1;
        PreparedStatement s = con.prepareStatement("INSERT INTO Orders(orderId, custId) VALUES(?, ?)");
        s.setInt(1, newMaxOrder1);
        s.setString(2, customerId);
        executeStatement(s);
        return new OrderData(newMaxOrder1, customerId);
    }

    private static int getMaxOrderId() throws SQLException {
        Statement qs = con.createStatement();
        ResultSet rs = qs.executeQuery("SELECT max(orderId) FROM Orders;");
        rs.next();
        int maxOrderId = rs.getInt(1);
        rs.close();
        return maxOrderId;
    }


    /**
     * 程序26.23 P300
     */
    public static void store(ItemData id) throws Exception {
        PreparedStatement s = buildItemInsersionStatement(id);
        executeStatement(s);
    }

    private static PreparedStatement buildItemInsersionStatement(ItemData id) throws SQLException {
        PreparedStatement s = con.prepareStatement("INSERT INTO Items(orderId, quantity, sku) VALUES(?, ?, ?);");
        s.setInt(1, id.orderId);
        s.setInt(2, id.qty);
        s.setString(3, id.sku);
        return s;
    }

    public static ItemData[] getItemsForOrder(int orderId) throws Exception {
        PreparedStatement s = buildItemsForOrderQueryStatement(orderId);
        ResultSet rs = s.executeQuery();
        ItemData[] id = extractItemDataFromResultSet(rs);
        rs.close();
        s.close();
        return id;
    }

    private static PreparedStatement buildItemsForOrderQueryStatement(int orderId) throws SQLException {
        PreparedStatement s = con.prepareStatement("SELECT * FROM Items WHERE orderId = ?;");
        s.setInt(1, orderId);
        return s;
    }

    private static ItemData[] extractItemDataFromResultSet(ResultSet rs) throws SQLException {
        LinkedList l = new LinkedList();
        for (int row = 0; rs.next(); row++) {
            ItemData id = new ItemData();
            id.orderId = rs.getInt("orderId");
            id.qty = rs.getInt("quantity");
            id.sku = rs.getString("sku");
            l.add(id);
        }
        return (ItemData[]) l.toArray(new ItemData[l.size()]);
    }

    public static OrderData getOrderData(int orderId) throws SQLException {
        PreparedStatement s = con.prepareStatement("SELECT custId FROM orders WHERE orderId = ?;");
        s.setInt(1, orderId);
        ResultSet rs = s.executeQuery();
        OrderData od = null;
        if (rs.next()) {
            od = new OrderData(orderId, rs.getString("custId"));
        }
        rs.close();
        s.close();
        return od;
    }
}
