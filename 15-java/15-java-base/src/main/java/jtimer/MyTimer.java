package jtimer;

import java.text.SimpleDateFormat;
import java.util.Timer;

/**
 * 定时调度类
 * <p> Timer 已经过时，如想要查看运行效果，放开下面注释即可 </p>
 * 可以用 java.util.concurrent.ScheduledExecutorService 来实现定时任务
 *
 * @author zc 2017-05-24
 */
public class MyTimer {

    public static void main(String[] args) {
        System.out.println(System.getProperty("java.class.path"));
        // C:\Java\jdk1.8.0_172\jre\lib\charsets.jar;C:\Java\jdk1.8.0_172\jre\lib\deploy.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\access-bridge-64.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\cldrdata.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\dnsns.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\jaccess.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\jfxrt.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\localedata.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\nashorn.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\sunec.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\sunjce_provider.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\sunmscapi.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\sunpkcs11.jar;C:\Java\jdk1.8.0_172\jre\lib\ext\zipfs.jar;C:\Java\jdk1.8.0_172\jre\lib\javaws.jar;C:\Java\jdk1.8.0_172\jre\lib\jce.jar;C:\Java\jdk1.8.0_172\jre\lib\jfr.jar;C:\Java\jdk1.8.0_172\jre\lib\jfxswt.jar;C:\Java\jdk1.8.0_172\jre\lib\jsse.jar;C:\Java\jdk1.8.0_172\jre\lib\management-agent.jar;C:\Java\jdk1.8.0_172\jre\lib\plugin.jar;C:\Java\jdk1.8.0_172\jre\lib\resources.jar;C:\Java\jdk1.8.0_172\jre\lib\rt.jar;G:\IDworkspace\study-imooc\15-java\15-java-base\target\classes;D:\software\Maven\repository\org\apache\commons\commons-lang3\3.8.1\commons-lang3-3.8.1.jar;D:\Program Files\JetBrains\IntelliJ IDEA 2021.2.3\lib\idea_rt.jar
/*

        // 创建一个 Timer 实例
        Timer timer = new Timer();

        // 创建一个 MyTimerTask 实例
        MyTimerTask myTimerTask = new MyTimerTask("No.1");

        // 通过 Timer 定时定频率调用 MyTimerTask 的业务逻辑
        // 即第一次执行是在当前时间的两秒之后，之后每隔一秒钟执行一次
        timer.schedule(myTimerTask, 2000L);

        System.out.println("schedule time is " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(myTimerTask.scheduledExecutionTime()));
*/

        /*
         * 获取当前时间，并设置成距离当前时间三秒之后的时间
         * 如当前时间是2016-11-10 23:59:57
         * 则设置后的时间则为2016-11-11 00:00:00
         */
        // Calendar calendar = Calendar.getInstance();
        // 定义日期格式
        // SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        // System.out.println("Current exec time is : " + simpleDateFormat.format(calendar.getTime()));
        // calendar.add(Calendar.SECOND, 3);

        // schedule的四种用法
        /*
         * 1.在时间等于或超过time的时候执行仅且执行一次task
         *   如在2016-11-11 00:00:00执行一次task，打印任务名字
         */
        // myTimerTask.setName("schedule1");
        // timer.schedule(myTimerTask,calendar.getTime());

        /*
         * 2.时间等于或超过time首次执行task
         *   之后每隔period毫秒重复执行一次task
         *   如在2016-11-11 00:00:00第一次执行task，打印任务名字
         *   之后每隔两秒执行一次task
         */
        // myTimerTask.setName("schedule2");
        // timer.schedule(myTimerTask,calendar.getTime(),2000L);

        /*
         * 3.等待delay毫秒后仅执行且执行一个task
         *   如现在是2016-11-11 00:00:00
         *   则在2016-11-11 00:00:01执行一次task，打印任务名字
         */
        // myTimerTask.setName("schedule3");
        // timer.schedule(myTimerTask,1000L);

        /*
         * 4.等到delay毫秒后首次执行task
         *   之后每隔period毫秒重复执行一次task
         *   如现在是2016-11-11 00:00:00
         *   则在2016-11-11 00:00:01第一次执行task，打印任务名字
         *   之后每隔两秒执行一次task
         */
        // myTimerTask.setName("schedule4");
        // timer.schedule(myTimerTask,1000L,2000L);

        // scheduleAtFixedRate的两种用法
        /*
         * 1.时间等于或超过time时首次执行task
         *   之后每隔period毫秒重复执行一次task
         *   如在2016-11-11 00:00:00第一次执行task，打印任务名字
         *   之后每隔两秒执行一次task
         */
        // myTimerTask.setName("scheduleAtFixedRate1");
        // timer.scheduleAtFixedRate(myTimerTask,calendar.getTime(),2000L);

        /*
         * 2.等待delay毫秒后首次执行task
         *   之后每隔period毫秒重复执行一次task
         *   如现在是2016-11-11 00:00:00
         *   则在2016-11-11 00:00:01第一次执行task，打印任务名字
         *   之后每隔两秒执行一次task
         */
        // myTimerTask.setName("scheduleAtFixedRate2");
        // timer.scheduleAtFixedRate(myTimerTask,1000L,2000L);
    }
}
