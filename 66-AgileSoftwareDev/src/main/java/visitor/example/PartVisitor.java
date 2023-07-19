package visitor.example;

/**
 * 程序28.20
 */
public interface PartVisitor {
    void visit(PiecePart piecePart);
    void visit(Assembly assembly);
}
