package scrum.v4;

/**
 * P50~P52
 */
public class Game {
    private int itsScore = 0;
    private int[] itsThrows = new int[21];
    private int itsCurrentThrow = 0;
    private int itsCurrentFrame = 0;
    private Boolean firstThrow = true;

    public int score(){
        return itsScore;
    }

    public int getCurrentFrame() {
        //return 1; // 无趣
        //return 1 + (itsCurrentThrow -1)/2; // 这不太令人满意
        return itsCurrentFrame;
    }

    public void add(int pins) {
        itsThrows[itsCurrentThrow++] = pins;
        itsScore += pins;
//        if (firstThrow == true) {
//            firstThrow = false;
//            itsCurrentFrame++;
//        } else {
//            firstThrow = true;
//        }
        adjustCurrentFrame();
    }

    private void adjustCurrentFrame() {
        if (firstThrow == true) {
            firstThrow = false;
            itsCurrentFrame++;
        } else {
            firstThrow = true;
        }
    }

    // frameScore == 10 时不应该对变量 ball 递增。把这个讨厌的额外递增操作去掉。
    public int scoreForFrame(int theFrame) {
        int ball = 0;
        int score = 0;
        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
            int firstThrow = itsThrows[ball++];
            int secondThrow = itsThrows[ball++];

            int frameScore = firstThrow + secondThrow;
            if (frameScore == 10) {
                score += frameScore + itsThrows[ball];
            } else {
                score += frameScore;
            }
        }
        return score;
    }

}
