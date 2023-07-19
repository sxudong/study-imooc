package decorator;

/**
 * 程序28.24
 */
public interface Modem {
    void dial(String pno);
    void setSpeakerVolume(int volume);
    String getPhoneNumber();
    int getSpeakerVolume();
}
