package visitor.acyclic;

/**
 * 程序28.14
 */
public class HayesModem implements Modem {
    public String configurationString = null;

    @Override
    public void dial(String pno) {

    }

    @Override
    public void hangup() {

    }

    @Override
    public void send(char c) {

    }

    @Override
    public char recv() {
        return 0;
    }

    @Override
    public void accept(ModemVisitor visitor) {
        try {
            HayesVisitor hv = (HayesVisitor) visitor;
            hv.visit(this);
        } catch (ClassCastException e) {

        }
    }
}
