package socket.nio.chat;

import java.io.Closeable;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.nio.charset.Charset;
import java.util.Set;

/**
 * 第7章 实战：使用 NIO 改造多人聊天室 - 服务端
 *
 * Java的Selector封装了底层epoll和poll的API，可以通过指定如下参数来调用执行的内核调用, 在Linux平台，如果指定
 *   -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.PollSelectorProvider
 * 则底层调用poll，
 * 指定为：
 *   -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.EPollSelectorProvider
 * 或者不指定，则底层调用epoll。
 */
public class ChatServer {

    private static final int DEFAULT_PORT = 8888;

    private static final String QUIT = "quit";

    /**
     * 缓冲区大小
     */
    private static final int BUFFER = 1024;

    /**
     * 服务器端通道，使用通道进行通信
     */
    private ServerSocketChannel serverSocketChannel;

    /**
     * 选择器,负责注册监听所有事件
     */
    private Selector selector;

    /**
     * 用来读取消息的 buffer
     */
    private ByteBuffer rBuffer = ByteBuffer.allocate(BUFFER);

    /**
     * 用来写入信息的 buffer
     */
    private ByteBuffer wBuffer = ByteBuffer.allocate(BUFFER);

    private Charset charset = Charset.forName("UTF-8");

    private int port;

    public ChatServer() {
        this.port = DEFAULT_PORT;
    }

    public ChatServer(int port) {
        this.port = port;
    }

    /**
     * 检查是否退出
     */
    public boolean readyToQuit(String msg) {
        return QUIT.equals(msg);
    }

    /**
     * 开始启动
     */
    public void start() {
        try {
            // 创建一个 ServerSocketChannel通道
            serverSocketChannel = ServerSocketChannel.open();
            // 设置通道为未非阻塞（默认是阻塞的）
            serverSocketChannel.configureBlocking(false);
            // 绑定到监听端口
            serverSocketChannel.socket().bind(new InetSocketAddress(port));
            // /创建一个 selector 多路复用选择器,负责注册监听所有事件
            selector = Selector.open();
            /** 1. “服务端通道”上注册需要监听的 ACCEPT 客户端连接请求事件 */
            // 把需要处理的“IO事件”注册给 Selector。
            // Selector内部的原理为：对所有注册的 Channel 进行轮询访问，一旦轮询到一个 Channel_1 有注册的事件发生，它就会通知
            // selectedKey 的方式来通知开发人员对 Channel_1 和一个特定的 selector 之间的关系。
            // 底层调用 Selector.register() 注册通道：((AbstractSelector)selector).register(this, ops, att);
            serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);
            System.out.println("启动服务器，监听端口:" + port + ".....");

            // 进入监听模式
             while (true) {
                // select()函数是阻塞式的,直到有事件触发了才会返回。如果事件没到达就一直阻塞着。
                selector.select();
                // 获取监听事件，返回的是所有触发了的事件所对应的 SelectionKey 对象的集合，拿到 Selector 关心的已经到达事件的 SelectionKey 集合
                // 每一个被触发的事件与他相关的信息都包装在 SelectionKey 中。
                Set<SelectionKey> selectionKeys = selector.selectedKeys();
                for (SelectionKey selectionKey : selectionKeys) {  //迭代触发事件
                    /** 2. 处理被触发事件 */
                    handles(selectionKey);
                }
                // 手动把已处理的事件清空
                selectionKeys.clear();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            close(selector);
        }
    }

    /**
     * 处理被触发事件
     * 主要处理两种事件
     *   1.客户端连接请求时间ACCEPT事件
     *   2.已连接的客户端发送消息后的READ事件
     */
    private void handles(SelectionKey selectionKey) throws IOException {
        // 如果是：ACCEPT事件 -- 和客户建立链接，并注册 READ 事件
        if (selectionKey.isAcceptable()) {
            // 获服务器通道，即返回为之创建此键的通道
            ServerSocketChannel server = (ServerSocketChannel) selectionKey.channel();
            // 获取客户端通道，并接受客户端连接请求
            SocketChannel client = server.accept();
            // 设置非阻塞
            client.configureBlocking(false);
            /**
             * 3. “客户端通道”上注册需要监听的 READ 事件
             */
            client.register(selector, SelectionKey.OP_READ);
            System.out.println("客户端[" + client.socket().getPort() + "]" + "客户端链接了");
        // 如果是：READ事件 --- 客户发送消息，有了可读的事件，读取信息后，取消监听
        } else if (selectionKey.isReadable()) {
            // 获取客户端通道，并读取客户端发送过来的消息
            SocketChannel client = (SocketChannel) selectionKey.channel();
            String fwMsg = receive(client);

            if (fwMsg.isEmpty()) {
                // 客户端异常，不再监听“READ事件”
                selectionKey.cancel();
                // 上一步取消了“READ事件”，更新 selector 监听的事件
                selector.wakeup();
            } else {
                // 消息转发给其他在线的客户端
                forwardMessage(client, fwMsg);
                // 检查用户是否退出
                if (readyToQuit(fwMsg)) {
                    selectionKey.cancel();
                    selector.wakeup();
                    System.out.println("客户端[" + client.socket().getPort() + "]" + "断开链接了");
                }
            }
        }

    }

    /**
     * 转发消息给客户端
     * @param client 发送消息的客户端本身
     * @param fwMsg  消息
     */
    private void forwardMessage(SocketChannel client, String fwMsg) throws IOException {
        // 发送消息首先找到客户端
        // selector.keys() 会返回所有目前已经注册在 selector 上的 SelectionKey 的集合，
        // 注册在 selector 上的 SelectionKey 即是当前在线的客户端
        for (SelectionKey key : selector.keys()) {

            // 跳过服务器端的通道 ServerSocketChannel
            // （在strt()方法中服务端通道 ServerSocketChannel 注册了“ACCEPT事件”，
            //   在handles()方法中 SocketChannel 客户端通道注册了“READ事件”）
            Channel connectedClient = key.channel();
            if (connectedClient instanceof ServerSocketChannel) {
                continue;
            }

            // 检测 channel 是有效的没有被关闭的，
            // 消息不能转发给自已，所以要判断通道不是自己本身。
            if (key.isValid() && !client.equals(connectedClient)) {
                // 首先把 wBuffer 里可能残余的数据清空，“读模式”翻转成“写模式”
                wBuffer.clear();
                // 把想要转发的数据写进 wBuffer 里
                wBuffer.put(charset.encode(fwMsg));
                // “写状态”翻转成“读状态”
                wBuffer.flip();
                // 如果里面还有数据就把它读写到通道里面去
                while (wBuffer.hasRemaining()) {
                    ((SocketChannel) connectedClient).write(wBuffer);
                }
            }
            System.out.println("客户端[" + client.socket().getPort() + "]" + fwMsg);
        }
    }

    /**
     * 读取 channel 上面的信息
     * @param client
     */
    private String receive(SocketChannel client) throws IOException {
        // 清理残留的内容
        rBuffer.clear();
        // 读到 rBuffer 中去
        while (client.read(rBuffer) > 0) ;
        // 写模式切换回读模式
        rBuffer.flip();
        return String.valueOf(charset.decode(rBuffer));
    }

    /**
     * 关闭资源
     */
    public void close(Closeable closeable) {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        ChatServer charServer = new ChatServer(DEFAULT_PORT);
        charServer.start();
    }
}
