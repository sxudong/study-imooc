package scrum.v9;

/**
 * P58~P62  重构
 */
public class Game {

    int ball = 0;
    int firstThrow;
    int secondThrow;

    private int itsScore = 0;
    private int[] itsThrows = new int[21];
    private int itsCurrentThrow = 0;
    private int itsCurrentFrame = 1;
    //private Boolean firstThrow = true;
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
        //if (firstThrow == true) {
        if (firstThrowInFrame == true) {
            if (pins == 10) { // strike 全中
                itsCurrentFrame++;
            } else {
                //firstThrow = false;
                firstThrowInFrame = false;
            }
        } else {
            //firstThrow = true;
            firstThrowInFrame = true;
            itsCurrentFrame++;
        }

        itsCurrentFrame = Math.min(11, itsCurrentFrame);
        //itsCurrentFrame = Math.min(10, itsCurrentFrame);
    }

    public int scoreForFrame(int theFrame) {
        ball = 0;
        int score = 0;
        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
            //firstThrow = itsThrows[ball++];
            firstThrow = itsThrows[ball];

            if (firstThrow == 10) {
                ball++;
                score += 10 + itsThrows[ball] + itsThrows[ball+1];
            } else {
//                secondThrow = itsThrows[ball++];
//                int frameScore = firstThrow + secondThrow;
//                // spare needs next frames first throw 如果有补中的情况，那么要在下一个球投掷后该论才算完整。
//                if (frameScore == 10) {
//                    score += frameScore + itsThrows[ball];
//                } else {
//                    score += frameScore;
//                }
                score += handleSecondThrow();
            }
        }
        return score;
    }

    private int handleSecondThrow() {
        int score = 0;
        //secondThrow = itsThrows[ball++];
        secondThrow = itsThrows[ball + 1];

        int frameScore = firstThrow + secondThrow;
        // spare needs next frames first throw
        // 如果有补中的情况，那么要在下一个球投掷后该论才算完整。
        if (frameScore == 10) {
            ball += 2;
            score += frameScore + itsThrows[ball];
        } else {
            ball += 2;
            score += frameScore;
        }
        return score;
    }

}
