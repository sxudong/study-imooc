package design.principle.compositionaggregation.v2;

/**
 * 3-11 合成复用原则讲解
 */
public class Test {
    public static void main(String[] args) {
        /*
         * 如果我们还有再进行扩展的话，那么我们就再写上一个类 ，
         * 然后去实现DBConnection里面的抽象方法，具体的实现由
         * 调用者自己去决定new哪一个实现的实例。
         */
        ProductDao productDao = new ProductDao();
        productDao.setDbConnection(new PostgreSQLConnection());
        productDao.addProduct();
    }
} /* Output:
使用PostgreSQL数据库连接增加产品
*///~

