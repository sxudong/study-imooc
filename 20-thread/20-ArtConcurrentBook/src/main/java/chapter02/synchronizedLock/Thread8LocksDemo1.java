package chapter02.synchronizedLock;

import java.util.concurrent.TimeUnit;
/**
 * 8��������������°������Σ�
 *   1.��׼���ʣ��ȷ����ʼ����Ƕ���
 *   2.���ʼ���������ͣ4�룬�ȷ����ʼ����Ƕ���
 *   3.������ͨ��hello�������ȴ�ӡhello�����ȷ����ʼ�
 *   4.���������ֻ�ʵ�������ȴ�ӡ���Ż����ȷ����ʼ�
 *   5.2����̬ͬ��������һ���ֻ�ʵ�����ȷ����Ż����ȷ��ʼ�
 *   6.2����̬ͬ�������������ֻ�ʵ�����ȷ����Ż����ȷ��ʼ�
 *   7.1����̬ͬ��������1����ͨͬ��������һ���ֻ�ʵ�����ȷ����Ż����ȷ��ʼ�
 *   8.1����̬ͬ��������1����ͨͬ�������������ֻ�ʵ�����ȷ����Ż����ȷ��ʼ�
 *
 * ��ʾ��ʵ�ֵ�1�֣��͵�2������
 *
 * ԭ�����ӣ�https://blog.csdn.net/weixin_44868739/article/details/114868470
 */
class Phone {

    public synchronized void send_email() throws Exception {
        // �ʼ���������ͣ 4 ��
        TimeUnit.SECONDS.sleep(4);
        System.out.println("-------send e-mail-----");
    }

    public synchronized void send_message() throws Exception {
        System.out.println("-------send message-----");
    }
}

public class Thread8LocksDemo1 {
    /**
     * ���̲߳�������Դ�� Phone���������� synchronized ͬ�����������ʼ��ͷ����ţ�
     * main ������ new ��һ�� Phone ʵ�����󣬲����� A, B �����߳�ȥ����phone����
     */
    public static void main(String[] args) throws InterruptedException {
        Phone phone = new Phone();
        System.out.println("Thread A begin start");
        new Thread(() -> {
            try {
                phone.send_email();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "A").start();

        Thread.sleep(100);
        System.out.println("Thread B begin start");
        new Thread(() -> {
            try {
                phone.send_message();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, "B").start();
    }
    /* �ӽ�����Կ�����
     * ���н����Ȼ���ȷ����ʼ��ٷ��Ͷ��ţ������ڴ�ӡ֮ǰ�ȴ���4��
     *
     * �����ƶϣ�һ��������������ж�� synchronized ��������ĳһʱ��ֻҪ��һ���߳�ȥ��������һ��
     * ͬ�������������̶߳�ֻ�ܵȴ����� ĳһʱ���ڣ�ֻ����Ψһһ���߳�ȥ������Щ synchronized ������
     * Ҳ����˵ synchronized ���������� phoneʵ�����󣬶���������һ��������
     *
     * �����������еİ����������䣺
     *     ����ֻ��һ̨iphone12����Ҫ�������ʼ�����ǿҪ�����������ţ����������õ��ֻ�����ǿֻ�ܵ�
     *     �ұ༭�������ʼ������ֻ������������ܽ��в�������������ͬʱ���С�
     */
}
/* Output:
Thread A begin start
Thread B begin start
-------send e-mail-----
-------send message-----
 */
