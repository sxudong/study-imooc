package visitor.acyclic;

/**
 * 程序28.8
 */
public interface Modem {
    void dial(String pno);
    void hangup();
    void send(char c);
    char recv();
    void accept(ModemVisitor visitor);
}