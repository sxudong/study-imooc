package extensionObject.impl;

import extensionObject.Assembly;
import extensionObject.Part;
import extensionObject.PartExtension;
import extensionObject.XMLPartExtension;
import org.jdom2.Element;

import java.util.Iterator;

/**
 * 程序28.37 P364
 */
public class XMLAssemblyExtension implements XMLPartExtension {
    private Assembly itsAssembly = null;

    public XMLAssemblyExtension(Assembly assy) {
        this.itsAssembly = assy;
    }

    @Override
    public Element getXMLElement() {
        Element e = new Element("Assembly");
        e.addContent(new Element("PartNumber").setText(itsAssembly.getPartNumber()));
        e.addContent(new Element("Description").setText(itsAssembly.getDescription()));

        Element parts = new Element("Parts");
        e.addContent(parts);

        Iterator i = itsAssembly.getParts();
        while (i.hasNext()) {
            Part p = (Part) i.next();
            PartExtension pe = p.getExtension("XML");
            XMLPartExtension xpe = (XMLPartExtension) pe;
            parts.addContent(xpe.getXMLElement());

        }
        return e;
    }
}
