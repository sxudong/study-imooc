package design.pattern.behavioral.observer.monitor.spring.event.listener;

import org.springframework.context.ApplicationEvent;

/**
 * 自定义一个新的事件
 */
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