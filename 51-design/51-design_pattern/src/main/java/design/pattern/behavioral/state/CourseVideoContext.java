package design.pattern.behavioral.state;

/**
 * 课程视频上下文
 */
public class CourseVideoContext {

    private CourseVideoState courseVideoState;
    public final static PlayState PLAY_STATE = new PlayState();
    public final static StopState STOP_STATE = new StopState();
    public final static PauseState PAUSE_STATE = new PauseState();
    public final static SpeedState SPEED_STATE = new SpeedState();

    public CourseVideoState getCourseVideoState() {
        return courseVideoState;
    }

    public void setCourseVideoState(CourseVideoState courseVideoState) {
        this.courseVideoState = courseVideoState;
        //把当前的环境通知到各个实现类中
        //4个状态子类靠 super.courseVideoContext.setCourseVideoState(CourseVideoContext.PLAY_STATE); 来修改状态
        this.courseVideoState.setCourseVideoContext(this);
    }

    public void play() {
        this.courseVideoState.play();
    }

    public void speed() {
        this.courseVideoState.speed();
    }

    public void stop() {
        this.courseVideoState.stop();
    }

    public void pause() {
        this.courseVideoState.pause();
    }
}
