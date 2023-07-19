package decorator.multi;

import decorator.Modem;

/**
 * 28.4.1 多个 Decorator
 * 程序28.29 P358
 */
public class LoudDialModem extends ModemDecorator {
    public LoudDialModem(Modem m) {
        super(m);
    }

    public void dial(String pno) {
        getModem().setSpeakerVolume(10);
        getModem().dial(pno);
    }
}
