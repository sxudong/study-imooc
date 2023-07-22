package scrum.v18;

/**
 * P70~P70
 * Game对象只知晓Frame(第几轮)
 */
public class Game {

    private int itsCurrentFrame = 1;
    private boolean firstThrowInFrame = true;
    private Scorer itsScorer = new Scorer();

    public int score() {
        return scoreForFrame(itsCurrentFrame);
    }

    public void add(int pins) {
        itsScorer.addThrow(pins);
        adjustCurrentFrame(pins);
    }

    private void adjustCurrentFrame(int pins) {
        //if((firstThrowInFrame && pins == 10) || (!firstThrowInFrame))
        if(strike(pins) || (!firstThrowInFrame))
            advanceFrame();
        else
            firstThrowInFrame = false;
    }

    // ##### add #####
    private boolean strike(int pins) {
        return (firstThrowInFrame && pins == 10);
    }
    // ###############

    private void advanceFrame() {
        itsCurrentFrame = Math.min(10, itsCurrentFrame + 1);
    }

    public int scoreForFrame(int theFrame) {
        return itsScorer.scoreForFrame(theFrame);
    }
}
