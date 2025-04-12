package com.hibernate.xml;

import java.beans.PropertyVetoException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import com.mchange.v2.c3p0.PooledDataSource;

public class C3P0DatasourceTest {
    private String driverClass;
    private String jdbcUrl;
    private String user;
    private String password;
    private String keyHost;
    private int minPoolSize = 5;
    private int maxPoolSize = 20;
    private int acquireIncrement = 5;
    private int initialPoolSize = 5;
    private int maxIdleTime = 300;
    private int defaultRowPrefetch = 200;
    private int idleConnectionTestPeriod = 30;
    private String preferredTestQuery = "SELECT 1 FROM DUAL";
    private int maxConnectionAge = 7200;
    private int maxStatementsPerConnection = 0;
    public ComboPooledDataSource dataSource;
    private Long readTimeout = 6000L; //120min - 20min

    public void initDatabase() {
        dataSource = new ComboPooledDataSource();
        Properties properties = new Properties();
        properties.setProperty("defaultRowPrefetch", String.valueOf(defaultRowPrefetch));
        //only oracle database use this property
        properties.setProperty("oracle.jdbc.ReadTimeout", String.valueOf(readTimeout * 1000));
        dataSource.setProperties(properties);
        try {
            dataSource.setDriverClass("com.mysql.jdbc.Driver");
            dataSource.setJdbcUrl("jdbc:mysql://localhost:3306/demo");
            dataSource.setUser("root");
            dataSource.setPassword("root");
            // the settings below are optional -- c3p0 can work with defaults
            dataSource.setInitialPoolSize(3);
            dataSource.setMinPoolSize(3);
            dataSource.setMaxPoolSize(5);
            dataSource.setAcquireIncrement(5);
            dataSource.setMaxIdleTime(1000);
            dataSource.setAutoCommitOnClose(false);
            //dataSource.setCheckoutTimeout(5000);
            //dataSource.setUnreturnedConnectionTimeout(1000);
            //dataSource.setBreakAfterAcquireFailure(true);
            //dataSource.setMaxIdleTimeExcessConnections(3);
            dataSource.setPreferredTestQuery("SELECT 1 FROM DUAL");
            dataSource.setMaxConnectionAge(7200);
            dataSource.setMaxStatementsPerConnection(0);
        } catch (PropertyVetoException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Connection getConnection() throws SQLException {
        Connection connection = dataSource.getConnection();
        connection.setAutoCommit(false);
        return connection;
    }

    public void cleanup() {
        try {
            if (dataSource != null) {
                dataSource.close();
            }
        } catch (Exception e) {
            //LOGGER.error(e);
        }
    }

    public String toString() {
        StringBuilder builder = new StringBuilder(super.toString());
        builder.append(",jdbcUrl=").append(jdbcUrl);
        builder.append(",user=").append(user);
        builder.append(",minSize=").append(minPoolSize);
        builder.append(",maxSize=").append(maxPoolSize);
        return builder.toString();
    }

    public static void main(String[] args) {
        C3P0DatasourceTest util = new C3P0DatasourceTest();
        util.initDatabase();
        util.showConnPoolInfo(util.dataSource);
        Connection conn = null;
        try {
            conn = util.getConnection();
            conn.commit();
            util.showConnPoolInfo(util.dataSource);
            Connection conn2 = util.getConnection();
            conn2.commit();
            util.showConnPoolInfo(util.dataSource);
            Connection conn3 = util.getConnection();
            conn3.commit();
            util.showConnPoolInfo(util.dataSource);
            Connection conn4 = util.getConnection();
            conn4.commit();
            util.showConnPoolInfo(util.dataSource);
            Connection conn5 = util.getConnection();
            conn5.commit();
            Thread.sleep(5000);
            util.showConnPoolInfo(util.dataSource);
            Thread.sleep(5000);
            Connection conn6 = util.getConnection();
            conn6.commit();
            util.showConnPoolInfo(util.dataSource);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } finally {
            try {
                conn.close();
            } catch (SQLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            util.showConnPoolInfo(util.dataSource);
        }
    }

    private static void showConnPoolInfo(ComboPooledDataSource pool) {
        PooledDataSource pds = (PooledDataSource) pool;
        if (null != pds) {
            try {
                System.out.println("------------c3p0连接池链接状态--------------");
                System.out.println("c3p0连接池中 【 总共 】 连接数量：" + pds.getNumConnectionsDefaultUser());
                System.out.println("c3p0连接池中 【  忙  】 连接数量：" + pds.getNumBusyConnectionsDefaultUser());
                System.out.println("c3p0连接池中 【 空闲 】 连接数量：" + pds.getNumIdleConnectionsDefaultUser());
                System.out.println("c3p0连接池中 【未关闭】 连接数量：" + pds.getNumUnclosedOrphanedConnectionsAllUsers());
            } catch (SQLException e) {
                System.out.println("c3p0连接池异常！");
            }
        }
    }
}