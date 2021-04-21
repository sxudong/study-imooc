package design.principle.compositionaggregation.v2;

/**
 * 3-11 合成复用原则讲解
 * 现在需要再用Oracle的数据库来进行连接。
 * 我们对之前的连接的类进行修改，改成了抽象类
 */
public abstract class DBConnection {
//    public String getConnection(){
//        return "MySQL数据库连接";
//    }
    public abstract String getConnection();
}
