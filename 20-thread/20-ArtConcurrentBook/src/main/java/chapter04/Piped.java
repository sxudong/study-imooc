package chapter04;

import java.io.IOException;
import java.io.PipedReader;
import java.io.PipedWriter;

/**
 * 代码清单 4-12
 * 4.3.4 管道输入/输出流
 *
 * 例子中，创建了 printThread，它用来接受 main 线程的输入，任何 main 线程的输入
 * 均通过 PipedWriter 写入，而 printThread 在另一端通过 PipedReader 将内容读出
 * 并打印。
 */
public class Piped {

    public static void main(String[] args) throws Exception {
        PipedWriter out = new PipedWriter();
        PipedReader in = new PipedReader();
        // 将输出流和输入流进行连接，否则在使用时会抛出IOException
        out.connect(in); // in.connect(out) 也行，必需绑定

        Thread printThread = new Thread(new Print(in), "PrintThread");
        printThread.start();
        int receive = 0;
        try {
            while ((receive = System.in.read()) != -1) {
                // main 线程的输入均通过 PipedWriter 写入，printThread 在另一端通过 PipedReader 将内容读出并打印
                out.write(receive);
            }
        } finally {
            out.close();
        }
    }

    //打印
    static class Print implements Runnable {
        private PipedReader in; //管道输入流

        public Print(PipedReader in) {
            this.in = in;
        }

        @Override
        public void run() {
            int receive = 0;
            try {
                while ((receive = in.read()) != -1) {
                    System.out.print((char) receive);
                }
            } catch (IOException ex) {
            }
        }
    }
}
