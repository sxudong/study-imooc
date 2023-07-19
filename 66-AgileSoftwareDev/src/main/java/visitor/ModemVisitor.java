package visitor;

public interface ModemVisitor {
    void visit(HayesModem modem);
    void visit(ZoomModem modem);
    void visit(ErnieModem modem);
}
