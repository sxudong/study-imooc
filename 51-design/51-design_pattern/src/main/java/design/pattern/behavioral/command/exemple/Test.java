package design.pattern.behavioral.command.exemple;

public class Test {
  
    public static void main(String[] args) {  
        Receiver receiver = new Receiver();  
        Command cmd = new MyCommand(receiver);  // 创建具体命令，传入接收者

        Invoker invoker = new Invoker(cmd);     // 发动者
        invoker.action();                       // 执行命令
    }  
} /* Output:
command received!
*///~