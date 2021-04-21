package design.pattern.behavioral.command.exemple;

/**
 * 命令调动者
 */
public class Invoker {
      
    private Command command;  
      
    public Invoker(Command command) {  
        this.command = command;  
    }  
  
    public void action(){  
        command.exe();  
    }  
}  