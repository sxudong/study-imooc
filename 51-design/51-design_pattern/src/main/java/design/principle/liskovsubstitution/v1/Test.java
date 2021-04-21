package design.principle.liskovsubstitution.v1;


/**
 * 3-9 里氏替换原则讲解
 *
 * 示例违背里氏替换原则
 */
public class Test {
    public static void resize(Rectangle rectangle) {

        while (rectangle.getWidth() <= rectangle.getLength()) {
        //while (rectangle.getWidth() < rectangle.getLength()) {
            rectangle.setWidth(rectangle.getWidth() + 1);
            System.out.println("width: " + rectangle.getWidth() + " length: " + rectangle.getLength());
        }

        System.out.println("resize方法结束，width: " + rectangle.getWidth() + " length: " + rectangle.getLength());
    }


    public static void main(String[] args) {
        // 长方形
        Rectangle rectangle = new Rectangle();
        rectangle.setWidth(10);
        rectangle.setLength(20);
        resize(rectangle);
    }

}
/* Output:
width: 11 length: 20
width: 12 length: 20
width: 13 length: 20
width: 14 length: 20
width: 15 length: 20
width: 16 length: 20
width: 17 length: 20
width: 18 length: 20
width: 19 length: 20
width: 20 length: 20
width: 21 length: 20
resize方法结束，width: 21 length: 20
*///~