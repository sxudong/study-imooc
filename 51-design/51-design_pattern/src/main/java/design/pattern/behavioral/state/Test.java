package design.pattern.behavioral.state;

/**
 * 27-2 状态模式
 * 这个demo逻辑还有一点问题，参考《设计模式之禅》的状态模式设计的demo
 *
 * org.springframework.context.Lifecycle
 */
public class Test {
    public static void main(String[] args) {
        CourseVideoContext courseVideoContext = new CourseVideoContext();
        courseVideoContext.setCourseVideoState(new PlayState());
        courseVideoContext.play();

        // getClass().getSimpleName()也就是类名了
        System.out.println("当前状态：" + courseVideoContext.getCourseVideoState().getClass().getSimpleName());
        courseVideoContext.pause();

        System.out.println("当前状态：" + courseVideoContext.getCourseVideoState().getClass().getSimpleName());
        courseVideoContext.speed();

        System.out.println("当前状态：" + courseVideoContext.getCourseVideoState().getClass().getSimpleName());
        courseVideoContext.stop();

        System.out.println("当前状态：" + courseVideoContext.getCourseVideoState().getClass().getSimpleName());

        courseVideoContext.speed();
    }
}
/* Output:
正常播放课程视频状态
当前状态：PlayState
当前状态：PauseState
当前状态：SpeedState
当前状态：StopState
ERROR 停止状态不能快进！！
*///~