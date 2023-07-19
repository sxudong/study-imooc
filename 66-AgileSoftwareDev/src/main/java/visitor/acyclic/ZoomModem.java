package visitor.acyclic;

/**
 * 程序28.15
 */
public class ZoomModem implements Modem {
    public int configurationString = 0;

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
            ZoomVisitor zv = (ZoomVisitor) visitor;
            zv.visit(this);
        } catch (ClassCastException e) {

        }
    }
}
