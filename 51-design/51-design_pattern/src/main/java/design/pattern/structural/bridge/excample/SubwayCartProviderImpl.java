package design.pattern.structural.bridge.excample;

/**
 * 服务提供者实现类  (相当于com.mysql.jdbc.Driver)
 */  
public class SubwayCartProviderImpl implements SubwayProviderInterface {
  
    static {
        // 注册
        ServiceManager.registerProvider("一卡通", new SubwayCartProviderImpl());
    }  
  
    public SubWayInterface getService() {  
        return new SubWayCartImpl();
    }  
  
} 
