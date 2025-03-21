package socket.aio.echo;

import java.io.BufferedReader;
import java.io.Closeable;
import java.io.InputStreamReader;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.AsynchronousSocketChannel;
import java.util.concurrent.Future;

/**
 * 第8章 JavaIO的“后世”之师：AIO异步通信模型
 * 客户端使用 Future 的方式来实现异步 - AIO
 * AsynchronousSocketChannel
 */
public class EchoClient {

    final String LOCALHOST = "localhost";

    final int DEFAULT_PORT = 8888;

    AsynchronousSocketChannel clientChannel;

    /**
     * 回收资源
     *
     * @param close
     */
    private void close(Closeable close) {
        if (null != close) {
            try {
                close.close();
                System.out.println("关闭" + close);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public void start() {
        try {
            // 创建客户端channel
            clientChannel = AsynchronousSocketChannel.open();
            Future<Void> future = clientChannel.connect(new InetSocketAddress(LOCALHOST, DEFAULT_PORT));
            // 阻塞式调用get()方法，等待连接成功
            future.get();
            // 等待用户的输入
            BufferedReader consoleReader = new BufferedReader(new InputStreamReader(System.in));
            while (true) {
                String input = consoleReader.readLine(); // 阻塞式调用
                byte[] inputBytes = input.getBytes();
                // 构建ByteBuffer
                ByteBuffer buffer = ByteBuffer.wrap(inputBytes);
                // 客户端的Channel往服务器发送数据
                Future<Integer> writeResult = clientChannel.write(buffer);
                // 阻塞等待客户端往服务器发送数据完成
                writeResult.get();

                // 转换为“读模式”
                buffer.flip();
                // 把clientChannel里面的数据写进buffer里去
                Future<Integer> readResult = clientChannel.read(buffer);
                // 阻塞获取服务器返回的数据
                readResult.get();

                String echo = new String(buffer.array());
                System.out.println(echo);
                buffer.clear();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(clientChannel);
        }
    }

    public static void main(String[] args) {
        EchoClient client = new EchoClient();
        client.start();
    }

}
