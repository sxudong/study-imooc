package scrum.v16;

/**
 * P69~P70 现在来看看 11
 * Game对象只知晓Frame(第几轮)
 */
public class Game {

    private int itsCurrentFrame = 1;
    private boolean firstThrowInFrame = true;
    private Scorer itsScorer = new Scorer();

    public int score() {
        //return scoreForFrame(getCurrentFrame() - 1);
        return scoreForFrame(itsCurrentFrame);
    }

//    public int getCurrentFrame() {
//        return itsCurrentFrame;
//    }

    public void add(int pins) {
        itsScorer.addThrow(pins);
        adjustCurrentFrame(pins);
    }

    private void adjustCurrentFrame(int pins) {
        if (firstThrowInFrame == true) {
            if (adjustFrameForStrike(pins) == false) {
                firstThrowInFrame = false;
            }
        } else {
            firstThrowInFrame = true;
            advanceFrame();
        }
    }

    private boolean adjustFrameForStrike(int pins) {
        if (pins == 10) { // strike 全中
            advanceFrame();
            return true;
        }
        return false;
    }

    private void advanceFrame() {
        //itsCurrentFrame = Math.min(11, itsCurrentFrame + 1);
        itsCurrentFrame = Math.min(10, itsCurrentFrame + 1);
    }

    public int scoreForFrame(int theFrame) {
        return itsScorer.scoreForFrame(theFrame);
    }
}
