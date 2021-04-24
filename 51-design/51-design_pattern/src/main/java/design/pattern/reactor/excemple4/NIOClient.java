package design.pattern.reactor.excemple4;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.util.Iterator;

/**
 * http://www.zyiz.net/tech/detail-108686.html
 */
public class NIOClient {
    public static void main(String[] args) {
        try {
            Selector selector = Selector.open();
            SocketChannel clientChannel = SocketChannel.open();
            clientChannel.configureBlocking(false);
            clientChannel.connect(new InetSocketAddress(8080));
            clientChannel.register(selector, SelectionKey.OP_CONNECT);
            while (true) {
                //如果事件没到达就一直阻塞着
                selector.select();
                Iterator<SelectionKey> iterator = selector.selectedKeys().iterator();
                while (iterator.hasNext()) {
                    SelectionKey key = iterator.next();
                    iterator.remove();
                    if (key.isConnectable()) {
                        /**
                         * 连接服务器端成功
                         *
                         * 首先获取到clientChannel，然后通过Buffer写入数据，然后为clientChannel注册OP_READ事件
                         */
                        clientChannel = (SocketChannel) key.channel();
                        if (clientChannel.isConnectionPending()) {
                            clientChannel.finishConnect();
                        }
                        clientChannel.configureBlocking(false);
                        ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
                        byteBuffer.clear();
                        byteBuffer.put("服务端你好，我是客户端".getBytes("UTF-8"));
                        byteBuffer.flip();
                        clientChannel.write(byteBuffer);
                        clientChannel.register(key.selector(), SelectionKey.OP_READ);
                    } else if (key.isReadable()) {
                        //通道可以读数据
                        clientChannel = (SocketChannel) key.channel();
                        ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
                        long bytesRead = clientChannel.read(byteBuffer);
                        while (bytesRead > 0) {
                            byteBuffer.flip();
                            System.out.println("server data ：" + new String(byteBuffer.array()));
                            byteBuffer.clear();
                            bytesRead = clientChannel.read(byteBuffer);
                        }
                    } else if (key.isWritable() && key.isValid()) {
                        //通道可以写数据
                        System.out.println("客户端写");
                        SocketChannel sc = (SocketChannel)key.channel();
                        ByteBuffer buffer = ByteBuffer.allocate(1024);
                        buffer.put("hello server.".getBytes());
                        buffer.flip();
                        sc.write(buffer);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
/* Output:
server data ：客户端你好
 */