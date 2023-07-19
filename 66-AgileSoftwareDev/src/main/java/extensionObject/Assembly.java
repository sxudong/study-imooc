package extensionObject;

import extensionObject.impl.CSVAssemblyExtension;
import extensionObject.impl.CSVPiecePartExtension;
import extensionObject.impl.XMLAssemblyExtension;
import extensionObject.impl.XMLPiecePartExtension;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * 程序28.34 P363
 */
public class Assembly extends Part {
    private List itsParts = new LinkedList();
    private String itsPartNumber;
    private String itsDescription;

    public Assembly(String itsPartNumber, String itsDescription) {
        this.itsPartNumber = itsPartNumber;
        this.itsDescription = itsDescription;
        addExtension("CSV", new CSVAssemblyExtension(this));
        addExtension("XML", new XMLAssemblyExtension(this));
    }

    public void add(Part part) {
        itsParts.add(part);
    }

    public Iterator getParts() {
        return itsParts.iterator();
    }

    @Override
    public String getPartNumber() {
        return itsPartNumber;
    }

    @Override
    public String getDescription() {
        return itsDescription;
    }
}
