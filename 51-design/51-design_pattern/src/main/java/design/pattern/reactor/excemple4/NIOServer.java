package design.pattern.reactor.excemple4;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Iterator;
import java.util.Set;

/**
 * http://www.zyiz.net/tech/detail-108686.html
 */
public class NIOServer {
    public static void main(String[] args) {
        try {
            //创建一个多路复用选择器
            Selector selector = Selector.open();
            //创建一个ServerSocket通道，并监听8080端口
            ServerSocketChannel serverSocketChannel = ServerSocketChannel.open().bind(new InetSocketAddress(8080));
            //设置为非阻塞
            serverSocketChannel.configureBlocking(false);
            //监听接收数据的事件
            serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);

            while (true) {
                //如果事件没到达就一直阻塞着
                selector.select();
                //拿到 Selector 关心的已经到达事件的 SelectionKey 集合
                Set keys = selector.selectedKeys();
                Iterator iterator = keys.iterator();
                while (iterator.hasNext()) {
                    SelectionKey selectionKey = (SelectionKey) iterator.next();
                    iterator.remove();
                    //因为我们只注册了 ACCEPT 事件，所以这里只写了当连接处于这个状态时的处理程序
                    if (selectionKey.isAcceptable()) {
                        //拿到产生这个事件的通道
                        ServerSocketChannel serverChannel = (ServerSocketChannel) selectionKey.channel();
                        SocketChannel clientChannel = serverChannel.accept();
                        clientChannel.configureBlocking(false);
                        //并为这个通道注册一个读事件
                        clientChannel.register(selectionKey.selector(), SelectionKey.OP_READ);
                    } else if (selectionKey.isReadable()) {
                        SocketChannel clientChannel = (SocketChannel) selectionKey.channel();
                        ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
                        long bytesRead = clientChannel.read(byteBuffer);
                        while (bytesRead > 0) {
                            byteBuffer.flip();
                            System.out.println("来自客户端的数据 ：" + new String(byteBuffer.array()));
                            byteBuffer.clear();
                            bytesRead = clientChannel.read(byteBuffer);
                        }
                        byteBuffer.clear();
                        byteBuffer.put("客户端你好".getBytes("UTF-8"));
                        byteBuffer.flip();
                        clientChannel.write(byteBuffer);
                    }
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
/* Output:
来自客户端的数据 ：服务端你好，我是客户端
 */