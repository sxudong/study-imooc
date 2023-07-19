package visitor.example;

/**
 * 程序28.21
 */
public class ExplodedCostVisitor implements PartVisitor {
    private double cost = 0;

    public double cost() {
        return cost;
    }

    @Override
    public void visit(PiecePart piecePart) {
        cost += piecePart.getCost();
    }

    @Override
    public void visit(Assembly assembly) {
    }

}
