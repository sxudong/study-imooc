package design.pattern.behavioral.state;

/**
 * 课程视频状态
 */
public abstract class CourseVideoState {
    protected CourseVideoContext courseVideoContext;

    public void setCourseVideoContext(CourseVideoContext courseVideoContext) {
        this.courseVideoContext = courseVideoContext;
    }

    public abstract void play();  // 播放状态
    public abstract void speed(); // 快进状态
    public abstract void pause(); // 暂停状态
    public abstract void stop();  // 停止状态
}
