package design.pattern.behavioral.command.imooic;

/**
 * 23-2 命令模式coding
 */
public class Test {
    public static void main(String[] args) {
        // 接收者
        CourseVideo courseVideo = new CourseVideo("Java设计模式 —— By Geely");
        // 具体命令
        OpenCourseVideoCommand openCourseVideoCommand = new OpenCourseVideoCommand(courseVideo);
        CloseCourseVideoCommand closeCourseVideoCommand = new CloseCourseVideoCommand(courseVideo);

        // 员工————发动者
        Staff staff = new Staff();
        // 保存到命令列表中
        staff.addCommand(openCourseVideoCommand);
        staff.addCommand(closeCourseVideoCommand);
        // 按命令顺序执行
        staff.executeCommands();
    }
}
/* Output:
Java设计模式 —— By Geely课程开放
Java设计模式 —— By Geely课程关闭
*///~