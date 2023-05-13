package scrum.v2;

/**
 * P43~P48
 */
public class Game {
    private int itsScore = 0;
    private int[] itsThrows = new int[21];
    private int itsCurrentThrow = 0;

    public int score(){
        return itsScore;
    }

    public void add(int pins) {
        itsThrows[itsCurrentThrow++] = pins;
        itsScore += pins;
    }

//    public int scoreForFrame(int frame) {
//        int score = 0;
//        for (int ball = 0; frame > 0 && (ball < itsCurrentThrow); ball += 2, frame--) {
//            score +=  itsThrows[ball] + itsThrows[ball + 1];
//        }
//        return score;
//    }

    // 优化一下 for 循环
//    public int scoreForFrame(int theFrame) {
//        int ball = 0;
//        int score = 0;
//        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
//            score +=  itsThrows[ball++] + itsThrows[ball++];
//        }
//        return score;
//    }

    // score += 这个表达式有副作用
    public int scoreForFrame(int theFrame) {
        int ball = 0;
        int score = 0;
        for (int currentFrame = 0; currentFrame < theFrame; currentFrame++) {
            int firstThrow = itsThrows[ball++];
            int secondThrow = itsThrows[ball++];
            score += firstThrow + secondThrow;
        }
        return score;
    }
}
