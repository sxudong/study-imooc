package extensionObject.impl;

import extensionObject.CSVPartExtension;
import extensionObject.PiecePart;


/**
 * 程序28.39 P365
 */
public class CSVPiecePartExtension implements CSVPartExtension {
    private PiecePart itsPiecePart = null;

    public

    CSVPiecePartExtension(PiecePart part) {
        this.itsPiecePart = part;
    }

    @Override
    public String getCSV() {
        StringBuffer b = new StringBuffer("PiecePart,");
        b.append(itsPiecePart.getPartNumber());
        b.append(",");
        b.append(itsPiecePart.getDescription());
        b.append(",");
        b.append(itsPiecePart.getCost());
        return b.toString();
    }
}
