package visitor;

public class UnixModemConfigurator implements ModemVisitor {
    @Override
    public void visit(HayesModem modem) {
        modem.configurationString = "&s1=4&D=3";
    }

    @Override
    public void visit(ZoomModem modem) {
        modem.configurationString = 42;
    }

    @Override
    public void visit(ErnieModem modem) {
        modem.configurationPattern = "C is too slow";
    }
}
