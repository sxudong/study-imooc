package visitor.example;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * 程序28.18
 */
public class Assembly implements Part {
    private List itsParts = new LinkedList<>();
    private String itsPartNumber;
    private String itsDescription;

    public Assembly(String itsPartNumber, String itsDescription) {
        this.itsPartNumber = itsPartNumber;
        this.itsDescription = itsDescription;
    }

    @Override
    public String getPartNumber() {
        return itsPartNumber;
    }

    @Override
    public String getDescription() {
        return itsDescription;
    }

    @Override
    public void accept(PartVisitor visitor) {
        visitor.visit(this);
        Iterator i = getParts();
        while (i.hasNext()) {
           Part p =  (Part) i.next();
           p.accept(visitor);
        }
    }

    public void add(Part part) {
        itsParts.add(part);
    }

    public Iterator getParts() {
        return itsParts.iterator();
    }
}
