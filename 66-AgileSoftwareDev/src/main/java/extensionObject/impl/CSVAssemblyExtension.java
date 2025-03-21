package extensionObject.impl;

import extensionObject.Assembly;
import extensionObject.CSVPartExtension;
import extensionObject.Part;

import java.util.Iterator;

/**
 * 程序28.40 P366
 */
public class CSVAssemblyExtension implements CSVPartExtension {
    private Assembly itsAssembly = null;

    public CSVAssemblyExtension(Assembly assy) {
        this.itsAssembly = assy;
    }

    @Override
    public String getCSV() {
        StringBuffer b = new StringBuffer("Assembly,");
        b.append(itsAssembly.getPartNumber());
        b.append(",");
        b.append(itsAssembly.getDescription());
        Iterator i = itsAssembly.getParts();
        while (i.hasNext()) {
            Part p = (Part) i.next();
            CSVPartExtension ce = (CSVPartExtension) p.getExtension("CSV");
            b.append(",{");
            b.append(ce.getCSV());
            b.append("}");
        }
        return b.toString();
    }
}
