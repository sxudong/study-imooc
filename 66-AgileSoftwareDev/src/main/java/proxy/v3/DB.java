package proxy.v3;

import java.sql.*;


/**
 * 程序26.9 P291
 * 代理会用这个连接去操作数据库。
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
}
