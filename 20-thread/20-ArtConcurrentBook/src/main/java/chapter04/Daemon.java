package chapter04;

/**
 * 代码清单 4-5
 * 4.1.5 Daemon（后台）线程
 */
public class Daemon {
    public static void main(String[] args) {
        Thread thread = new Thread(new DaemonRunner(), "DaemonRunner");
        thread.setDaemon(true);
        thread.start();
    }

    static class DaemonRunner implements Runnable {
        @Override
        public void run() {
            try {
                SleepUtils.second(10);
            } finally {
                //设置为守护线程后，前台不会打印
                System.out.println("DaemonThread finally run.");
            }
        }
    }
}