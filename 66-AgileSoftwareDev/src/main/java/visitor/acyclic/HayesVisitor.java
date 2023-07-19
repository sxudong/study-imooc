package visitor.acyclic;

/**
 * 程序28.11
 */
public interface HayesVisitor extends ModemVisitor {
    void visit(HayesModem hayesModem);
}
