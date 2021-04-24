package design.pattern.reactor.excemple3;
 
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.channels.ServerSocketChannel;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
 
 
/**
 * Reactor 主从 Reactor 模式实现
 * 
 * Acceptor,其实个人认为，这里就是服务端角色
 *
 * https://blog.csdn.net/prestigeding/article/details/55100075
 */
public class NioServer {
	
	private static final int DEFAULT_PORT = 9080;
	
	public static void main(String[] args) {
		new Thread(new Acceptor()).start();
	}
	
	
	private static class Acceptor implements Runnable {
		
		// main Reactor 线程池，用于处理客户端的连接请求
		private static ExecutorService mainReactor = Executors.newSingleThreadExecutor();
 
		public void run() {
			// TODO Auto-generated method stub
			ServerSocketChannel ssc = null;
			
			try {
				ssc = ServerSocketChannel.open();
				ssc.configureBlocking(false);
				ssc.bind(new InetSocketAddress(DEFAULT_PORT));
				
				//转发到 MainReactor反应堆
				dispatch(ssc);
				
				System.out.println("服务端成功启动。。。。。。");
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		private void dispatch(ServerSocketChannel ssc) {
			mainReactor.submit(new MainReactor(ssc));
		}
	}
}
/* Output:
Nio 线程数量：4
服务端成功启动。。。。。。
MainReactor is running
收到客户端的连接请求。。。
服务端接收客户端连接请求。。。
1024
业务在handler中开始执行。。。
业务在handler中执行结束。。。
服务端向客户端发送数据。。。
 */