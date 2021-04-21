package design.pattern.behavioral.observer.callback;


/**
 * 什么是回调函数?
 * 所谓的回调，用于回调的函数。回调函数只是一个功能片段，由用户按照回调函数调用约定来实现
 * 的一个函数。
 *
 * 参考：https://blog.csdn.net/qq_32252957/article/details/82763848
 */
public class CallTestDrive {
	public static void main(String args[]) {
		Caller call = new Caller();

		//第一种写法
//		call.call(new ICallBack() {
//			@Override
//			public void callBack() {
//				// TODO Auto-generated method stub
//				System.out.println("回调函数调用成功!");
//			}
//		});
		
		//第二种写法
		ICallBack callBack = new ICallBack() {
			@Override
			public void callBack() {
				// TODO Auto-generated method stub
				System.out.println("回调函数回调成功!");
			}
		};
		call.call(callBack);

		 // 第三种写法，实现这个ICallBack接口类
//		 class CallBackC implements ICallBack{
//		 	public void callBack(){
//		 	System.out.println("回调函数回调成功!");
//		 	}
//		 }
//		 call.call(new CallBackC());
	}
}

/* Output:
 Start...
  回调函数回调成功!
 End...
 */