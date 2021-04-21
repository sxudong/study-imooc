package design.pattern.behavioral.observer.monitor;

/**
 * 什么是事件监听器?
 * 监听器将监听自己感兴趣的事件，一旦该事件被触发或改变，立即得到通知，做出响应。
 *
 * java的事件监听机制可概括为3点:
 * 		1.java的事件监听机制涉及到事件源、事件监听器、事件对象三个组件，监听器一般是接口，用来约定调用的方式。
 * 		2.当事件源对象上发生操作时，它会将调用事件监听器的一个方法，并在调用该方法时传递事件对象过去。
 * 		3.事件监听器实现类通常是由开发人员编写，在事件监听器里开发人员通过事件对象拿到事件源，从而对事件源上
 * 		  的操作进行处理。
 *
 * 监听器模式：事件源经过事件的封装传给监听器，当事件源触发事件后，监听器接收到事件对象可以回调事件的方法
 *
 * 观察者模式：观察者(Observer)相当于事件监听者，被观察者(Observable)相当于事件源和事件，执行逻辑时通知
 *            observer即可触发 oberver 的 update,同时可传被观察者和参数
 *
 * 参考：https://blog.csdn.net/qq_32252957/article/details/82763848
 */
public class MonitorTestDrive {
	public static void main(String[] args) {

		EventSource eventSource = new EventSource();
		eventSource.addListener(new MonitorListener() {
			@Override
			public void handleEvent(PrintEvent event) {          // EventObject 做为 Listener 的处理参数
				// TODO Auto-generated method stub
				event.doEvent();
				// 根据不同的事件源执行不同的逻辑代码
				if(event.getSource().equals("openWindows")) {
					System.out.println("doOpen");
				}
				if(event.getSource().equals("closeWindows")){
					System.out.println("doClose");
				}
			}
		});

		// 触发事件
		// 传入 openWindows事件，通知所有的事件监听器对 open事件 感兴趣的 listener 将会执行
		eventSource.notifyListenerEvents(new PrintEvent("openWindows")); // 遍历执行 handleEvent()

		/**
		 * 有了了解后，这里还可以做一些变动。对特定的事件提供特定的关注方法和事件触发
		 * 关注关闭事件，实现回调接口
		 */
		EventSource windows = new EventSource();
		windows.addCloseWindowListener(new MonitorListener() {
			@Override
			public void handleEvent(PrintEvent event) {           // EventObject 做为 Listener 的处理参数
				// TODO Auto-generated method stub
				event.doEvent();
				if(event.getSource().equals("closeWindows")) {
					System.out.println("通过addCloseWindowListener来关注关闭窗口事件，并执行成功" + "closeWindows");
				}
			}
		});

		// 触发事件
		// 窗口关闭动作 ———— 现在是不是类似按钮注册监听器，然后点击触发点击事件，执行监听器中对应事件的动作
		// 会调用 notifyListenerEvents(new PrintEvent("closeWindows"));
		windows.doCloseWindows();
	}
}

/* Output:
通知一个事件源 source: openWindows
doOpen
关注关闭窗口事件
通知一个事件源 source: closeWindows
通过onCloseWindows来关注关闭窗口事件，并执行成功closeWindows
*/























