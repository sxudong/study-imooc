package design.pattern.structural.bridge.excample;

/**
 * 一卡通地铁进出服务实现 
 */  
public class SubWayCartImpl implements SubWayInterface {
  
    public boolean in() {  
        System.out.println("通过一卡通进入地铁");  
        /** 
         * 进行一些处理，然后返回是否放行 
         */  
        return false;  
    }  
  
    public boolean out() {  
        System.out.println("通过一卡通出地铁");  
        /** 
         * 进行一些处理，然后返回是否放行 
         */  
        return false;  
    }  
  
}  
