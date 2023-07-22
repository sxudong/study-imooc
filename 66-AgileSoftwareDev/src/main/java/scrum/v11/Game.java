package scrum.v11;

/**
 * P64~P65
 */
public class Game {

    int ball = 0;
    private int itsScore = 0;
    private int[] itsThrows = new int[21];
    private int itsCurrentThrow = 0;
    private int itsCurrentFrame = 1;
    private boolean firstThrowInFrame = true;
    public int score(){
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

    public int scoreForFrame(int theFrame) {
        ball = 0;
        int score = 0;
        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
            if (strike()) { // 全中
                ball++;
                score += 10 + nextTwoBalls();
            }
//          else {
//              score += handleSecondThrow();
//          }
            else if (spare()) { // 补中
                ball += 2;
                score += 10 + nextBall();
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

    private int nextTwoBalls() {
        return itsThrows[ball] + itsThrows[ball+1];
    }

    private int handleSecondThrow() {
        int score = 0;
        // spare needs next frames first throw
        // 如果有补中的情况，那么要在下一个球投掷后该论才算完整。
        if(spare()) {
            ball += 2;
            score += 10 + nextBall();
        } else {
            score += twoBallsInFrame();
            ball += 2;
        }
        return score;
    }

    private int twoBallsInFrame() {
        return itsThrows[ball] + itsThrows[ball + 1];
    }

    private int nextBall() {
        return itsThrows[ball];
    }

    private boolean spare() {
        return (itsThrows[ball] + itsThrows[ball + 1]) == 10;
    }


}
