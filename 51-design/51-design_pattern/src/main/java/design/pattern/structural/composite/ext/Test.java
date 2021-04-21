package design.pattern.structural.composite.ext;

import org.apache.commons.collections.map.LinkedMap;

import java.util.HashMap;
import java.util.Map;

/**
 * 组合模式，“树枝构件”和“树叶构件”都实现了“抽象构件角色”
 */
public class Test {
    public static void main(String[] args) {
        Map<String, Integer> map1 = new HashMap<String, Integer>();
        map1.put("aa", 1);
        map1.put("bb", 2);
        map1.put("cc", 3);
        System.out.println("map1: " + map1);

        //LinkedMap也实现了Map接口，所以它可以做为组件添加
        Map<String, Integer> map2 = new LinkedMap();
        map2.put("cc", 4);
        map2.put("dd", 5);
        System.out.println("map2: " + map2);

        map1.putAll(map2);
        System.out.println("map1.putAll(map2): " + map1);
    }
}