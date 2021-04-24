package design.pattern.reactor.excemple3;
 
import java.io.Serializable;
import java.nio.channels.SocketChannel;
 
/**
 * Nio task
 *
 * https://blog.csdn.net/prestigeding/article/details/55100075
 */
public class NioTask implements Serializable {
	
	private SocketChannel sc;
	private int op;
	private Object data;
	
	public NioTask(SocketChannel sc, int op) {
		this.sc = sc;
		this.op = op;
	}
	
	public NioTask(SocketChannel sc, int op, Object data) {
		this(sc, op);
		this.data = data;
	}
	public SocketChannel getSc() {
		return sc;
	}
	public void setSc(SocketChannel sc) {
		this.sc = sc;
	}
	public int getOp() {
		return op;
	}
	public void setOp(int op) {
		this.op = op;
	}
	public Object getData() {
		return data;
	}
	public void setData(Object data) {
		this.data = data;
	}
	
	
 
}