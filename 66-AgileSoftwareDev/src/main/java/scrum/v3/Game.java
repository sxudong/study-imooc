package scrum.v3;

/**
 * P48~P50
 */
public class Game {
    private int itsScore = 0;
    private int[] itsThrows = new int[21];
    private int itsCurrentThrow = 0;

    public int score() {
        return itsScore;
    }

    public void add(int pins) {
        itsThrows[itsCurrentThrow++] = pins;
        itsScore += pins;
    }

//    public int scoreForFrame(int theFrame) {
//        int ball = 0;
//        int score = 0;
//        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
//            int firstThrow = itsThrows[ball++];
//            int secondThrow = itsThrows[ball++];
//            score += firstThrow + secondThrow;
//        }
//        return score;
//    }

    //    public int scoreForFrame(int theFrame) {
//        int ball = 0;
//        int score = 0;
//        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
//            int firstThrow = itsThrows[ball++];
//            int secondThrow = itsThrows[ball++];
//
//            int frameScore = firstThrow + secondThrow;
//            if (frameScore == 10) {
//                score += frameScore + itsThrows[ball++];
//            } else {
//                score += frameScore;
//            }
//        }
//        return score;
//    }

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
