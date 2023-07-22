package scrum.v20;

/**
 * 《敏捷软件开发 原则、模式与实践》第6章 一次编程实践 P71~P75
 */
public class Game {
    private int currentFrame = 0;
    private boolean isFirstThrow = true;
    private Scorer scorer = new Scorer();

    public int Score() {
        return ScoreForFrame(currentFrame);
    }

    public void Add(int pins) {
        scorer.AddThrow(pins);
        AdjustCurrentFrame(pins);
    }

    void AdjustCurrentFrame(int pins) {
        if (LastBallInFrame(pins))
            AdvanceFrame();
        else
            isFirstThrow = false;
    }

    private boolean LastBallInFrame(int pins) {
        return Strike(pins) || !isFirstThrow;
    }

    private boolean  Strike(int pins) {
        return isFirstThrow && pins == 10;
    }

    private void AdvanceFrame() {
        currentFrame++;
        if (currentFrame > 10) currentFrame = 10;
    }

    public int ScoreForFrame(int theFrame) {
        return scorer.ScoreForFrame(theFrame);
    }
}
