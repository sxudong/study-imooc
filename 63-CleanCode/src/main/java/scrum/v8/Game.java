package scrum.v8;

/**
 * P56~P58
 */
public class Game {
    private int itsScore = 0;
    private int[] itsThrows = new int[21];
    private int itsCurrentThrow = 0;
    private int itsCurrentFrame = 1;
    private Boolean firstThrow = true;

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
        if (firstThrow == true) {
            if (pins == 10) { // strike 全中
                itsCurrentFrame++;
            } else {
                firstThrow = false;
            }
        } else {
            firstThrow = true;
            itsCurrentFrame++;
        }

        // 限定到 10
        // itsCurrentFrame = Math.min(10, itsCurrentFrame);

        // score 函数把 getCurrentFrame 减了 1，所以它给出的是第9轮的得分，而不是第10轮的。
        // 把当前 frame 限定到 11 而不是 10？我再试试。
        itsCurrentFrame = Math.min(11, itsCurrentFrame);
    }

    public int scoreForFrame(int theFrame) {
        int ball = 0;
        int score = 0;
        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
            int firstThrow = itsThrows[ball++];

            if (firstThrow == 10) {
                score += 10 + itsThrows[ball] + itsThrows[ball+1];
            } else {
                int secondThrow = itsThrows[ball++];
                int frameScore = firstThrow + secondThrow;
                // spare needs next frames first throw 如果有补中的情况，那么要在下一个球投掷后该论才算完整。
                if (frameScore == 10) {
                    score += frameScore + itsThrows[ball];
                } else {
                    score += frameScore;
                }
            }
        }
        return score;
    }

}
