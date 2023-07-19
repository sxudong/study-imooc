package decorator;

/**
 * 程序28.25 P355
 */
public class HayesModem implements Modem {
    private String itsPhoneNumber;
    private int itsSpeakerVolume;

    @Override
    public void dial(String pno) {
        itsPhoneNumber = pno;
    }

    @Override
    public void setSpeakerVolume(int volume) {
        itsSpeakerVolume = volume;
    }

    @Override
    public String getPhoneNumber() {
        return itsPhoneNumber;
    }

    @Override
    public int getSpeakerVolume() {
        return itsSpeakerVolume;
    }

}
