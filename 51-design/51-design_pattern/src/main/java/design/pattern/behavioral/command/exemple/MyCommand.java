package design.pattern.behavioral.command.exemple;

/**
 * 具体的命令
 */
public class MyCommand implements Command {
  
    private Receiver receiver;  
      
    public MyCommand(Receiver receiver) {  
        this.receiver = receiver;  
    }  
  
    @Override  
    public void exe() {  
        receiver.action();  
    }  
}  