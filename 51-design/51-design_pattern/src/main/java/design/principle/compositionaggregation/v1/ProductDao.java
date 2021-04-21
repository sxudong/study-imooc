package design.principle.compositionaggregation.v1;

/**
 * 使用了继承，不符合合成复用原则
 */
public class ProductDao extends DBConnection {

    public void addProduct() {
        String conn = super.getConnection();
        System.out.println("使用"+conn+"增加产品");
    }
}