package design.pattern.reactor.excemple1;
 
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
 * Nio服务器，单线程模型
 * 本例主要用来增加对 Ractor 线程模型的理解，不会考虑半包等网络问题
 *
 * 例子程序的功能：服务器接受客户端的请求数据，然后在后面再追加 (hello,服务器收到了你的信息。)
 *
 * See：https://blog.csdn.net/prestigeding/article/details/55100075
 */
public class NioServer {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		(new Thread(new Reactor())).start();
	}

	/**
	 * Reacto模型，反应堆
	 */
	private static final class Reactor implements Runnable {

//		private static final ConcurrentHashMap<SocketChannel, ByteBuffer> waitSendData
//											= new ConcurrentHashMap<SocketChannel, ByteBuffer>();

		private static final byte[] b = "hello,服务器收到了你的信息。".getBytes();

		public void run() {
			// TODO Auto-generated method stub
			System.out.println("服务端启动成功，等待客户端接入");
			ServerSocketChannel ssc = null;
			Selector selector = null;
			try {
				//创建一个多路复用选择器
				selector = Selector.open();
				//创建一个 ServerSocket通道，并监听 9080 端口
				ssc = ServerSocketChannel.open();
				ssc.bind(new InetSocketAddress("127.0.0.1", 9080));
				//设置为非阻塞
				ssc.configureBlocking(false);
				//监听接收数据的事件
				ssc.register(selector, SelectionKey.OP_ACCEPT);

				Set<SelectionKey> ops = null;

				// 在 while() 内一直调用 select 获取被激活的 socket，一旦 socket 可读，
				// 便调用 read 函数将 socket 中的数据读取出来。
				while(true) {
					try {
						selector.select(); //如果没有感兴趣的事件到达，阻塞等待
						ops = selector.selectedKeys();
					} catch(Throwable e) {
						e.printStackTrace();
						break;
					}

					//处理相关事件
					for (Iterator<SelectionKey> it = ops.iterator(); it.hasNext();) {
						SelectionKey key =  it.next();
						it.remove();

						try {
							if(key.isAcceptable()) { //客户端建立连接
								ServerSocketChannel serverSc = (ServerSocketChannel) key.channel();//这里其实，可以直接使用ssl这个变量
								SocketChannel clientChannel = serverSc.accept();
								clientChannel.configureBlocking(false);

								//向选择器注册读事件，客户端向服务端发送数据准备好后，再处理
								clientChannel.register(selector, SelectionKey.OP_READ);

								System.out.println("收到客户端的连接请求。。。");
							} else if (key.isWritable()) { //向客户端发送请求
								SocketChannel clientChannel = (SocketChannel)key.channel();
								ByteBuffer buf = (ByteBuffer)key.attachment();
								buf.flip();
								clientChannel.write(buf);
								System.out.println("服务端向客户端发送数据。。。");
								//重新注册读事件
								clientChannel.register(selector, SelectionKey.OP_READ);
							} else if(key.isReadable()) {  //处理客户端发送的数据
								System.out.println("服务端接收客户端连接请求。。。");
//								System.out.println(key);
								SocketChannel clientChannel = (SocketChannel)key.channel();
//								System.out.println("clientChannel.isConnected():" + clientChannel.isConnected());
//								System.out.println("clientChannel.isConnectionPending():" +clientChannel.isConnectionPending());
//								System.out.println("clientChannel.isOpen():" + clientChannel.isOpen());
//								System.out.println("clientChannel.finishConnect():" + clientChannel.finishConnect());
								ByteBuffer buf = ByteBuffer.allocate(1024);
								System.out.println(buf.capacity());
								clientChannel.read(buf);//
								buf.put(b);
								clientChannel.register(selector, SelectionKey.OP_WRITE, buf);//注册写事件
							}
						} catch(Throwable e) {
							e.printStackTrace();
							System.out.println("客户端主动断开连接。。。。。。。");
							ssc.register(selector, SelectionKey.OP_ACCEPT);
						}

					}
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
}
/*Output:
服务端启动成功，等待客户端接入
收到客户端的连接请求。。。
服务端接收客户端连接请求。。。
1024
服务端向客户端发送数据。。。
*/