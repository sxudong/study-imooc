package visitor.example;

/**
 * 程序28.17
 */
public interface Part {
    String getPartNumber();
    String getDescription();
    void accept(PartVisitor visitor);
}
