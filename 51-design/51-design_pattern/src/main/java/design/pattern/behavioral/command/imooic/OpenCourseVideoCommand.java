package design.pattern.behavioral.command.imooic;

/**
 * 打开视频命令（具体的命令）
 */
public class OpenCourseVideoCommand implements Command {
    private CourseVideo courseVideo;

    public OpenCourseVideoCommand(CourseVideo courseVideo) {
        this.courseVideo = courseVideo;
    }

    @Override
    public void execute() {
       courseVideo.open();
    }
}
