package design.pattern.creational.singleton.imooic8;

import design.annoations.NotThreadSafe;
import org.apache.commons.lang3.StringUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * 8-9 单例设计模式 -- 容器单例
 *
 * 类似 Spring容器，这个 map 相当于缓存。《Effective Java》里有要注意自已使用 map 做缓存内存溢出问题
 */
@NotThreadSafe
public class ContainerSingleton {
    // 使用 map 来保存对象 (如果使用 ConcurrentHashMap 不能使用静态属性字段)
    private static Map<String,Object> singletonMap = new HashMap<String, Object>();

    private ContainerSingleton(){
    }

    public static void putInstance(String key, Object instance){
        if(StringUtils.isNotBlank(key) && instance != null){
            // 当不包含这个“对象”的时候才往里面放
            if(!singletonMap.containsKey(key)){
                singletonMap.put(key, instance);
            }
        }
    }

    public static Object getInstance(String key){
        return singletonMap.get(key);
    }

}
