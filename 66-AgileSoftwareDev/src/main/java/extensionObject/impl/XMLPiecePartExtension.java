package extensionObject.impl;


import extensionObject.PiecePart;
import extensionObject.XMLPartExtension;
import org.jdom2.Element;


/**
 * 程序28.36 P364
 */
public class XMLPiecePartExtension implements XMLPartExtension {
    private PiecePart itsPiecePart = null;

    public XMLPiecePartExtension(PiecePart part) {
        this.itsPiecePart = part;
    }

    @Override
    public Element getXMLElement() {
        Element e = new Element("PiecePart");
        e.addContent(new Element("PartNumber").setText(itsPiecePart.getPartNumber()));
        e.addContent(new Element("Description").setText(itsPiecePart.getDescription()));
        e.addContent(new Element("Cost").setText(Double.toString(itsPiecePart.getCost())));
        return e;
    }
}
