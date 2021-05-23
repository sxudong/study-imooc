package chapter11;

/**
 * 
 * @author tengfei.fangtf
 * @version $Id: Message.java, v 0.1 2015-8-1 上午12:14:46 tengfei.fangtf Exp $
 */

final class Message{ //单条消息
    private int id;
    private String message;

    public Message(int id, String message) {
        this.id = id;
        this.message = message;
    }
    public int getId() {
        return id;
    }
    public String getMessage() {
        return message;
    }
}