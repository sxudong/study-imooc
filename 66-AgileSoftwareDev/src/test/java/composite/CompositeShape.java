package composite;

import java.util.Vector;

/**
 * 第23章 COMPOSITE模式
 * 程序23.2 P258
 */
public class CompositeShape implements Shape {
    private Vector itsShapes = new Vector();

    public void add(Shape shape) {
        itsShapes.add(shape);
    }

    @Override
    public void draw() {
        for (int i = 0; i < itsShapes.size(); i++) {
            Shape shape = (Shape) itsShapes.elementAt(i);
            shape.draw();
        }
    }
}
