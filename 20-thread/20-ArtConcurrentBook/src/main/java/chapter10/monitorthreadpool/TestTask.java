package chapter10.monitorthreadpool;

/**
 * 普通任务类
 */
/*
public class TestTask implements Runnable {

    private Logger logger = LoggerFactory.getLogger(TestTask.class);

    private String taskName;

    public TestTask(String taskName) {
        this.taskName = taskName;
    }

    @Override
    public void run() {
        try {
            logger.debug(taskName + " is started.");
            Thread.sleep(1000);
            logger.debug(taskName + " is completed.");
        } catch (InterruptedException e) {
            logger.error(taskName + " is not completed.");
            e.printStackTrace();
        }
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getTaskName() {
        return taskName;
    }

    @Override
    public String toString() {
        return getTaskName();
    }
}
*/