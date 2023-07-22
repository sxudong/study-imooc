package scrum.v17;

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

    // adjustFrameForStrike() 有些表述不清，修改一下
    private void adjustCurrentFrame(int pins) {
//        if (firstThrowInFrame == true) {
//            if (adjustFrameForStrike(pins) == false) {
//                firstThrowInFrame = false;
//            }
//        } else {
//            firstThrowInFrame = true;
//            advanceFrame();
//        }
        if((firstThrowInFrame && pins == 10) || (!firstThrowInFrame))
            advanceFrame();
        else
            firstThrowInFrame = false;
    }

//    private boolean adjustFrameForStrike(int pins) {
//        if (pins == 10) { // strike 全中
//            advanceFrame();
//            return true;
//        }
//        return false;
//    }

    private void advanceFrame() {
        itsCurrentFrame = Math.min(10, itsCurrentFrame + 1);
    }

    public int scoreForFrame(int theFrame) {
        return itsScorer.scoreForFrame(theFrame);
    }
}
