package scrum.v13;

/**
 * P66~P68
 * Game对象只知晓Frame(第几轮)
 */
public class Game {

//    int ball = 0;
//    private int itsScore = 0;
//    private int[] itsThrows = new int[21];
//    private int itsCurrentThrow = 0;
    private int itsCurrentFrame = 1;
    private boolean firstThrowInFrame = true;
    // ### update ###
    private Scorer itsScorer = new Scorer();
    // ##############

    public int score() {
        return scoreForFrame(getCurrentFrame() - 1);
    }

    public int getCurrentFrame() {
        return itsCurrentFrame;
    }

    public void add(int pins) {
        // ### update ###
        itsScorer.addThrow(pins);
        // ##############
        //itsScore += pins;
        adjustCurrentFrame(pins);
    }

    private void adjustCurrentFrame(int pins) {
        if (firstThrowInFrame == true) {
            if (pins == 10) { // strike 全中
                itsCurrentFrame++;
            } else {
                firstThrowInFrame = false;
            }
        } else {
            firstThrowInFrame = true;
            itsCurrentFrame++;
        }

        itsCurrentFrame = Math.min(11, itsCurrentFrame);
    }

    // 现要可以使 ball 的增加方式一致，并为该函数取一个更清楚一些的名字。
    public int scoreForFrame(int theFrame) {
//        ball = 0;
//        int score = 0;
//        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
//            if (strike()) { // 全中
//                score += 10 + nextTwoBallsForStrike();
//                ball++;
//            } else if (spare()) { // 补中
//                score += 10 + nextBallForSpare();
//                ball += 2;
//            } else {
//                score += twoBallsInFrame();
//                ball += 2;
//            }
//        }
//        return score;
        return itsScorer.scoreForFrame(theFrame);
    }

//    private boolean strike() {
//        return itsThrows[ball] == 10;
//    }
//
//    private int nextTwoBallsForStrike() {
//        return itsThrows[ball + 1] + itsThrows[ball + 2];
//    }
//
//    private boolean spare() {
//        return (itsThrows[ball] + itsThrows[ball + 1]) == 10;
//    }
//
//    private int nextBallForSpare() {
//        return itsThrows[ball + 2];
//    }
//
//    private int twoBallsInFrame() {
//        return itsThrows[ball] + itsThrows[ball + 1];
//    }
}
