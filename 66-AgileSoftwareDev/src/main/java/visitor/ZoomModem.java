package visitor;

public class ZoomModem implements Modem{
    int configurationString = 0;

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
        visitor.visit(this);
    }
}
