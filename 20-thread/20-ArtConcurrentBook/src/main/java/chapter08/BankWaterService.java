package chapter08;

import java.util.Map;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 8.2.2 CyclicBarrier��Ӧ�ó��� �����嵥8-5
 *
 * ��һ��Excel�������û�����������ˮ��ÿ�� Sheet ����һ���˻���һ���ÿ��������ˮ��������
 * Ҫͳ���û����վ�������ˮ�����ö��̴߳���ÿ�� sheet ���������ˮ����ִ����֮�󣬵õ�ÿ��
 * sheet ���վ�������ˮ���������barrierAction����Щ�̵߳ļ���������������� Excel
 * ���վ�������ˮ�����´�����ʾ��
 */
public class BankWaterService implements Runnable {
    /**
     * ���� 4 �����ϣ�������֮��ִ�е�ǰ��� run ����
     *
     * CyclicBarrier �ṩһ�����߼��Ĺ��캯�� CyclicBarrier��int parties��Runnable barrierAction����
     * �������̵߳�������ʱ������ִ�� barrierAction�����㴦������ӵ�ҵ�񳡾�
     */
    private CyclicBarrier c = new CyclicBarrier(4, this);
    /**
     * ����ֻ�� 4 ��sheet������ֻ���� 4 ���߳�
     */
    private ExecutorService executor = Executors.newFixedThreadPool(4);
    /**
     * ����ÿ�� sheet ��������������
     */
    private ConcurrentHashMap<String, Integer> sheetBankWaterCount = new ConcurrentHashMap<>();

    //private AtomicInteger atomic = new AtomicInteger(1);

    private void count() {
        for (int i = 0; i < 4; i++) {
            executor.execute(new Runnable() {
                @Override
                public void run() {
                    // ���㵱ǰsheet���������ݣ��������ʡ��
                    sheetBankWaterCount.put(Thread.currentThread().getName(), 1);
                    // ����������ɣ�����һ������
                    try {
                        c.await(); //��4���̶߳���������CyclicBarrier c = new CyclicBarrier(4, this); this.run�����м��㡣
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    } catch (BrokenBarrierException e) {
                        e.printStackTrace();
                    }
                    //System.out.println(atomic.getAndIncrement());
                }
            });
        }
        executor.shutdown();
    }
 
    @Override
    public void run() {
        int result = 0;
        // ����ÿ��sheet������Ľ��
        for (Map.Entry<String, Integer> sheet : sheetBankWaterCount.entrySet()) {
            result += sheet.getValue();
        }
        // ��������
        sheetBankWaterCount.put("result", result);
        System.out.println(result);
    }
 
    public static void main(String[] args) {
        BankWaterService bankWaterCount = new BankWaterService();
        bankWaterCount.count();
    }
}
// ʹ���̳߳ش���4���̣߳��ֱ����ÿ��sheet������ݣ�ÿ��sheet��������1������
// BankWaterService�̻߳���4��sheet������Ľ��������������:
/*
4
 */