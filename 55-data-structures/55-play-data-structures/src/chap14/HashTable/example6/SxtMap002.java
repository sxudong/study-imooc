package chap14.HashTable.example6;

import java.util.LinkedList;

/**
 * 自定义 Map 的升级版：
 * 1. 提高查询的效率
 *
 * 尚学堂-07_容器和数据结构
 */
public class SxtMap002 {

	LinkedList[]  arr  = new LinkedList[9]; //Map的底层结构就是：数组+链表!
	int size;

	private int hash(Object key) {
		//做一个简单的优化
		int hash = key.hashCode(); //获得hashCode
		hash = hash < 0 ? -hash : hash;  //对负数做一个处理，如果是负数加 - 转为正数
		return hash % arr.length;
	}

	public void put(Object key,Object value){
		SxtEntry  e = new SxtEntry(key,value);

        //做一个简单的优化
        int hash = key.hashCode(); //获得hashCode
		hash = hash < 0 ? -hash : hash;  //对负数做一个处理，如果是负数加 - 转为正数

		// int a = key.hashCode() % arr.length; //获得hashCode
		int a = hash(key);
		if(arr[a] == null) {
			LinkedList list = new LinkedList();
			arr[a] = list;
			list.add(e);
		}else{
			LinkedList list = arr[a]; // 从数组中取出list赋值给新创建的list
			//如果key相同覆盖value
			for(int i = 0; i < list.size(); i++) {    // 遍历list
				SxtEntry e2 = (SxtEntry) list.get(i); // 取出SxtEntry
				if(e2.key.equals(key)){               // 比较key是否相同  
					e2.value = value;                 // key相同覆盖value
					return ; //返回，不再执行后面的arr[a].add(e);
				}
			}
			//如果key没有重复，直接添加
			arr[a].add(e); 
		}
		//a:1000-->1   b:10000-->13   假如a的hashcode是1000取余是1
	}

	public Object get(Object key){
		int a = key.hashCode()%arr.length; //获得hashCode
		if(arr[a] != null) {
			LinkedList list = arr[a];
			for(int i=0;i<list.size();i++){
				SxtEntry e = (SxtEntry) list.get(i);
				if(e.key.equals(key)){
					return e.value;
				}
			}
		}
		return null; //没找到，返回null
	}
	
	public static void main(String[] args) {
		SxtMap002 m = new SxtMap002();
		m.put("高琪", new Wife("杨幂"));
		m.put("高琪", new Wife("李四"));
		m.put("张三", new Wife("王五"));
		Wife w = (Wife) m.get("高琪");
		Wife s = (Wife)m.get("张三");
		System.out.println(w.name);  //李四
		System.out.println(s.name);
	}

}