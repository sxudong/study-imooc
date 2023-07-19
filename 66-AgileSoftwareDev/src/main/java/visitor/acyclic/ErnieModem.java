package visitor.acyclic;

/**
 * 程序28.13
 */
public class ErnieModem implements Modem {
    public String configurationPattern = null;

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
            ErnieVisitor ev = (ErnieVisitor) visitor;
            ev.visit(this);
        } catch (ClassCastException e) {

        }
    }
}