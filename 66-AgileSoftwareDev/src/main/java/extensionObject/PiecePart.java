package extensionObject;

import extensionObject.impl.CSVPiecePartExtension;
import extensionObject.impl.XMLPiecePartExtension;

/**
 * 程序28.31 P362
 */
public class PiecePart extends Part {
    private String itsPartNumber;
    private String itsDescription;
    private double itsCost;

    public PiecePart(String itsPartNumber, String itsDescription, double itsCost) {
        this.itsPartNumber = itsPartNumber;
        this.itsDescription = itsDescription;
        this.itsCost = itsCost;
        addExtension("CSV", new CSVPiecePartExtension(this));
        addExtension("XML", new XMLPiecePartExtension(this));
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
}
