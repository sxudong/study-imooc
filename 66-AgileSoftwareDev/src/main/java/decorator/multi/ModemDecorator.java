package decorator.multi;

import decorator.Modem;

/**
 * 28.4.1 多个 Decorator
 * 程序28.28 P357
 */
public class ModemDecorator implements Modem {
    private Modem itsModem;
    public ModemDecorator(Modem m) {
        itsModem = m;
    }

    @Override
    public void dial(String pno) {
        itsModem.dial(pno);
    }

    @Override
    public void setSpeakerVolume(int volume) {
        itsModem.setSpeakerVolume(volume);
    }

    @Override
    public String getPhoneNumber() {
        return itsModem.getPhoneNumber();
    }

    @Override
    public int getSpeakerVolume() {
        return itsModem.getSpeakerVolume();
    }

    protected Modem getModem() {
        return itsModem;
    }
}
