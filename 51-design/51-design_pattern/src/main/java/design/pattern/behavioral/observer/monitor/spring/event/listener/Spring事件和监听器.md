## Spring事件和监听器



目录 [[隐藏](http://www.heartthinkdo.com/?p=2708#)]

- [1 自定义事件](http://www.heartthinkdo.com/?p=2708#1)
- [2 Spring自带事件](http://www.heartthinkdo.com/?p=2708#2_Spring)

**本文概览**：介绍了Spring自带事件以及如何自定义一个事件和事件监听器

### 1 自定义事件

1、自定义一个新的事件

```java
public class MessageEvent extends ApplicationEvent {
    private String content;
 
    public MessageEvent(String content) {
        super(content);
        this.content = content;
    }
 
    public String getContent() {
        return content;
    }
 
    public void setContent(String content) {
        this.content = content;
    }
}
```



2、定义事件监听器。定义的事件监听器会在spring上下文初始化时，自动加载此listener。

```java
@Component
public class MessageEventListener implements ApplicationListener<MessageEvent> {
    @Override
    public void onApplicationEvent(MessageEvent event) {
        System.out.printf("event.message=" + event.getContent());
    }
}
```



3、测试发布事件和监听事件

```java
public class Excutor {

    public static void main(String[] args){
        ApplicationContext context = 
               new ClassPathXmlApplicationContext("classpath:/applicationContext.xml");
         // 发布事件
        context.publishEvent(new MessageEvent("执行完成"));
    }
} 
/* Output:
event.message=执行完成
*/
```



上述例子项目可以参考：



### 2 Spring自带事件

目前spring提供常用事件有：

（1）ContextRefreshedEvent，在执行完上下文初始化之后触发这个事件。

```java
类名：AbstractApplicationContext.java
 
  public void refresh() throws BeansException, IllegalStateException {
 	...
	// Last step: publish corresponding event.
	finishRefresh();
   }
 
 
  // 发布上下文
  protected void finishRefresh() {
	...
	// Publish the final event.
	publishEvent(new ContextRefreshedEvent(this));
 
		
  }
```

（2）ContextStartedEvent，在执行完start之后触发这个事件

```java
类名：AbstractApplicationContext.java
 
@Override
public void start() {
	getLifecycleProcessor().start();
	publishEvent(new ContextStartedEvent(this));
}
```

（3）ContextStartedEvent，在执行完stop之后触发这个事件

```java
类名：AbstractApplicationContext.java
 
  @Override
   public void stop() {
	  getLifecycleProcessor().stop();
	  publishEvent(new ContextStoppedEvent(this));
 }
```

（4）ContextClosedEvent，在执行完close之后触发这个事件

```java
	@Override
	public void close() {
		synchronized (this.startupShutdownMonitor) {
			doClose();
			// If we registered a JVM shutdown hook, we don't need it anymore now:
			// We've already explicitly closed the context.
			if (this.shutdownHook != null) {
				try {
                    // 通过这个钩子来触发这个close事件
					Runtime.getRuntime().removeShutdownHook(this.shutdownHook);
				}
				catch (IllegalStateException ex) {
					// ignore - VM is already shutting down
				}
			}
		}
	}
```
在springboot中可以实现优雅的停机,触发的就是上面这段代码。
```java
    private ApplicationContext context;
    /**
     * 停机
     */
    @PostMapping(value = "shutdown")
    public void shutdown() {
        ConfigurableApplicationContext cyx = (ConfigurableApplicationContext) context;
        cyx.close();
    }
```
