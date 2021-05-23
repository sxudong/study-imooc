package chapter04;

/**
 * �����嵥 4-5
 * 4.1.5 Daemon����̨���߳�
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
                //����Ϊ�ػ��̺߳�ǰ̨�����ӡ
                System.out.println("DaemonThread finally run.");
            }
        }
    }
}