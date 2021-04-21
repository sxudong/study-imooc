package design.principle.liskovsubstitution.v2;


/**
 * 3-9 里氏替换原则讲解
 *
 * 示例符合里氏替换原则
 *
 * 此时，如果我们把resize()方法的参数换成四边形接口 Quadrangle，方法内部就会报错。
 * 因为正方形类Square己经没有了setWidth() 和setHeight() 方法。
 * 因此，为了约束继承泛滥，resize()方法的参数只能用Rectangle类。
 */
public class Test {
    public static void resize(Quadrangle quadrangle) {

//        while (quadrangle.getWidth() <= quadrangle.getLength()) {
//            // 方法内部报错，没有setWidth()方法
//            quadrangle.setWidth(quadrangle.getWidth() + 1);
//            System.out.println("width: " + quadrangle.getWidth() + " length: " + quadrangle.getLength());
//        }

        System.out.println("resize方法结束，width: " + quadrangle.getWidth() + " length: " + quadrangle.getLength());
    }

    public static void resize2(Square square) {
        while (square.getWidth() <= square.getLength()) {
            square.setSideLength(square.getWidth() + 1);
            System.out.println("width: " + square.getWidth() + " length: " + square.getLength());
        }

        System.out.println("resize方法结束，width: " + square.getWidth() + " length: " + square.getLength());
    }

    public static void main(String[] args) {
        // 长方形
//        Rectangle rectangle = new Rectangle();
//        rectangle.setWidth(10);
//        rectangle.setLength(20);
//        resize(rectangle);

        // 正方形
        Square square = new Square();
        square.setSideLength(10);
        resize2(square);
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