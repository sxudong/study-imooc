package design.principle.compositionaggregation.v2;

/**
 * Created by geely
 */
public class PostgreSQLConnection extends DBConnection {
    @Override
    public String getConnection() {
        return "PostgreSQL数据库连接";
    }
}
