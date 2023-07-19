package visitor.example;

/**
 * 程序28.19
 */
public class PiecePart implements Part {
    private String itsPartNumber;
    private String itsDescription;
    private double itsCost;

    public PiecePart(String itsPartNumber, String itsDescription, double itsCost) {
        this.itsPartNumber = itsPartNumber;
        this.itsDescription = itsDescription;
        this.itsCost = itsCost;
    }

    @Override
    public String getPartNumber() {
        return itsPartNumber;
    }

    @Override
    public String getDescription() {
        return itsDescription;
    }

    public double getCost() {
        return itsCost;
    }

    @Override
    public void accept(PartVisitor visitor) {
        visitor.visit(this);
    }
}
