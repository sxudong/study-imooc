package scrum.v6;

/**
 * P50~P56
 */
public class Game {
    private int itsScore = 0;
    private int[] itsThrows = new int[21];
    private int itsCurrentThrow = 0;
    private int itsCurrentFrame = 1;
    private Boolean firstThrow = true;

    public int score(){
        //return itsScore;
        return scoreForFrame(getCurrentFrame() - 1);
    }

    public int getCurrentFrame() {
        return itsCurrentFrame;
    }

    public void add(int pins) {
        itsThrows[itsCurrentThrow++] = pins;
        itsScore += pins;
        //adjustCurrentFrame();
        adjustCurrentFrame(pins);
    }

    //private void adjustCurrentFrame() {
    private void adjustCurrentFrame(int pins) {
        if (firstThrow == true) {
            // ### add ###
            if (pins == 10) { // strike 全中
                itsCurrentFrame++;
            } else {
            // ###########
                firstThrow = false;
            }
        } else {
            firstThrow = true;
            itsCurrentFrame++;
        }
    }

    public int scoreForFrame(int theFrame) {
        int ball = 0;
        int score = 0;
        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
            int firstThrow = itsThrows[ball++];


            // ### add ###
            if (firstThrow == 10) {
                score += 10 + itsThrows[ball] + itsThrows[ball+1];
            } else {
            // ###########
                int secondThrow = itsThrows[ball++];
                int frameScore = firstThrow + secondThrow;
                // spare needs next frames first throw 补中后需要再投一次
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
