package design.pattern.structural.bridge.excample;

/**
 * 客户端测试类 
 */  
public class Test {  
    public static void main(String[] args) throws ClassNotFoundException {            
        Class.forName("design.pattern.structural.bridge.excample.SubwayCartProviderImpl");
        SubWayInterface swi = ServiceManager.getService("一卡通");  
        swi.in();  
        swi.out();  
    }  
} 