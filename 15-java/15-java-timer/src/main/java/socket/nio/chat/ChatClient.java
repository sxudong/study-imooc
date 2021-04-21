package socket.nio.chat;

import java.io.Closeable;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.ClosedSelectorException;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.nio.charset.Charset;
import java.util.Set;

/**
 * 使用 nio编程模型 实现多人聊天室 - 客户端
 */
public class ChatClient {

    private static final String DEFAULT_SERVER_HOST = "127.0.0.1";
    private static final int DEFAULT_SERVER_PORT = 9999;
    private static final String QUIT = "quit";
    private static final int BUFFER = 1024; //缓冲区大小
    private String host;
    private int port;
    private SocketChannel client;
    /**
     * 选择器
     */
    private Selector selector;
    /**
     * 用来读取消息的 buffer
     */
    private ByteBuffer rBuffer = ByteBuffer.allocate(BUFFER);
    /**
     * 用来写入信息的 buffer
     */
    private ByteBuffer wBeBuffer = ByteBuffer.allocate(BUFFER);
    private Charset charset = Charset.forName("UTF-8");

    public void start() {
        try {
            // 创建客户端通道
            client = SocketChannel.open();
            client.configureBlocking(false);
            selector = Selector.open();
            /** 注册"客户端"需要监听的连接事件 CONNECT */
            client.register(selector, SelectionKey.OP_CONNECT);
            // 向服务器发送连接请求
            client.connect(new InetSocketAddress(host, port));
            while (true) {
                selector.select();
                // 获取被触发的事件
                Set<SelectionKey> selectionKeys = selector.selectedKeys();
                for (SelectionKey selectionKey : selectionKeys) {
                    handles(selectionKey);
                }
                selectionKeys.clear();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClosedSelectorException e) {
            // 用户退出会抛出一个异常，在这里捕获，用户正常退出捕获后不做处理
        } finally {
            close(selector);
        }
    }

    /**
     * 处理被触发的事件
     *
     * @param selectionKey
     * @throws IOException
     */
    private void handles(SelectionKey selectionKey) throws IOException {
        // CONNECT 事件 --- 连接就绪事件
        if (selectionKey.isConnectable()) {
            // 获取 selectionKey 上对应的客户端通道
            SocketChannel client = (SocketChannel) selectionKey.channel();
            // 请求是否已经连接
            if (client.isConnectionPending()) { //true连接就绪状态
                // 正式建立连接
                client.finishConnect();
                // 使用阻塞线程等待处理用户的输入信息
                new Thread(new UserInputHandler(this)).start();
            }

            /** 注册 READ 事件，接收其他客户端转发过来的消息 */
            client.register(selector, SelectionKey.OP_READ);
        }
        // READ 事件 --- 服务器转发消息事件
        else if (selectionKey.isReadable()) {
            SocketChannel client = (SocketChannel) selectionKey.channel();
            String msg = receive(client);
            if (msg.isEmpty()) {
                // 服务器异常，关闭 selector，客户端退出
                close(selector);
            } else {
                System.out.println("客户端[" + client.socket().getPort() + "]" + msg);
            }
        }
    }

    /**
     * 读取消息
     *
     * @param client
     * @throws IOException
     */
    private String receive(SocketChannel client) throws IOException {
        // 首先清空 rBuffer 里可能残余的数据，“读模式”翻转成“写模式”
        rBuffer.clear();
        // 把数据写进 rBuffer 里,只要还可以读出字节，
        // 就不停的读下去，直到全部读完。
        while (client.read(rBuffer) > 0) ;
        // “写状态”翻转为“读状态”
        rBuffer.flip();
        return String.valueOf(charset.decode(rBuffer));
    }

    public ChatClient() {
        this(DEFAULT_SERVER_HOST, DEFAULT_SERVER_PORT);
    }

    public ChatClient(String host, int port) {
        this.host = host;
        this.port = port;
    }

    /**
     * 检查是否退出
     *
     * @param msg
     */
    public boolean readyToQuit(String msg) {
        return QUIT.equals(msg);
    }

    /**
     * 发送消息
     *
     * @param msg
     * @throws IOException
     */
    public void send(String msg) throws IOException {
        if (msg.isEmpty()) {
            return;
        }
        // 把 wBuffer 里可能残余的数据清空，“读模式”翻转成“写模式”
        wBeBuffer.clear();
        // 把想要转发的数据写进 wBuffer 里
        wBeBuffer.put(charset.encode(msg));
        // “写状态”翻转成“读状态”
        wBeBuffer.flip();
        // 如果里面还有数据就把它读写到通道里面去
        while (wBeBuffer.hasRemaining()) {
            client.write(wBeBuffer);
        }
        //检查用户是否准备推出
        if (readyToQuit(msg)) {
            close(selector);
        }
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
        ChatClient chartClient = new ChatClient("127.0.0.1", 8888);
        chartClient.start();
    }
}
