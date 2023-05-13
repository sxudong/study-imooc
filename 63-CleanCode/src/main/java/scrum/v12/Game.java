package scrum.v12;

/**
 * P64~P66
 */
public class Game {

    int ball = 0;
    private int itsScore = 0;
    private int[] itsThrows = new int[21];
    private int itsCurrentThrow = 0;
    private int itsCurrentFrame = 1;
    private boolean firstThrowInFrame = true;

    public int score() {
        return scoreForFrame(getCurrentFrame() - 1);
    }

    public int getCurrentFrame() {
        return itsCurrentFrame;
    }

    public void add(int pins) {
        itsThrows[itsCurrentThrow++] = pins;
        itsScore += pins;
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
        ball = 0;
        int score = 0;
        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
            if (strike()) { // 全中
                //ball++;
                //score += 10 + nextTwoBalls();
                score += 10 + nextTwoBallsForStrike();
                ball++;
            } else if (spare()) { // 补中
                //ball += 2;
                //score += 10 + nextBall();
                score += 10 + nextBallForSpare();
                ball += 2;
            } else {
                score += twoBallsInFrame();
                ball += 2;
            }
        }
        return score;
    }

    private boolean strike() {
        return itsThrows[ball] == 10;
    }

    //private int nextTwoBalls() {
    private int nextTwoBallsForStrike() {
//        return itsThrows[ball] + itsThrows[ball+1];
        return itsThrows[ball + 1] + itsThrows[ball + 2];
    }

//    private int handleSecondThrow() {
//        int score = 0;
//        // spare needs next frames first throw
//        // 如果有补中的情况，那么要在下一个球投掷后该论才算完整。
//        if(spare()) {
//            ball += 2;
//            score += 10 + nextBall();
//        } else {
//            score += twoBallsInFrame();
//            ball += 2;
//        }
//        return score;
//    }

    private boolean spare() {
        return (itsThrows[ball] + itsThrows[ball + 1]) == 10;
    }

    //private int nextBall() {
    private int nextBallForSpare() {
        //return itsThrows[ball];
        return itsThrows[ball + 2];
    }

    private int twoBallsInFrame() {
        return itsThrows[ball] + itsThrows[ball + 1];
    }
}
