package chapter03;

// ����ģʽ
public class Singleton{
    // Singleton���ʼ�����̰߳�ȫ����ֻ��ʼ��һ�Σ���֤instanceֻ��һ��
    // ������һ����̬�ֶα�ʹ�ã���������ֶβ���һ�������ֶΡ�
    private static Singleton instance = new Singleton();

    private Singleton() {
    }

    public static Singleton getInstance(){
        return instance;
    }
}