package extensionObject;

import java.util.HashMap;

/**
 * 程序28.31 P362
 */
public abstract class Part {
    HashMap itsExtensions = new HashMap();
    public abstract String getPartNumber();
    public abstract String getDescription();

    public void addExtension(String extensionType, PartExtension extension) {
        itsExtensions.put(extensionType, extension);
    }

    public PartExtension getExtension(String extensionType) {
        PartExtension pe = (PartExtension) itsExtensions.get(extensionType);
        if (pe == null) {
            pe = new BadPartExtenstion();
        }
        return pe;
    }
}
