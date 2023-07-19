package visitor.acyclic;

public class UnixModemConfigurator implements HayesVisitor, ZoomVisitor, ErnieVisitor, ModemVisitor {

    public void visit(HayesModem modem) {
        modem.configurationString = "&s1=4&D=3";
    }

    public void visit(ZoomModem modem) {
        modem.configurationString = 42;
    }

    public void visit(ErnieModem modem) {
        modem.configurationPattern = "C is too slow";
    }
}