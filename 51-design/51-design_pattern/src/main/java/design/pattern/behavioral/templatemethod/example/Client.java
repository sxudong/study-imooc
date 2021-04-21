package design.pattern.behavioral.templatemethod.example;

import design.pattern.behavioral.templatemethod.example.cache.Cache;
import design.pattern.behavioral.templatemethod.example.strategy.FIFOCache;

/**
 * 模板方法模式-缓存淘汰策略
 * https://javap.blog.csdn.net/article/details/111874247
 *
 * 场景：系统需要用到【支持超时的缓存】功能，不想因为这一个小场景去引入Redis，
 *      于是决定自己手写一个简单的缓存功能。
 *
 * 需求：
 *   1.基于内存的缓存功能。
 *   2.支持超时。
 *   3.缓存写满后启用淘汰机制清理缓存。
 *   4.需要支持多种淘汰策略，例如：FIFO、LFU、LRU等。
 *
 *   可以看到，缓存的大部分公用逻辑都在基类Cache中实现了，子类只需要实现自己的淘汰算法即可，
 *   如果要再新增一种淘汰策略也非常方便，继承Cache类，编写自己的淘汰算法即可，非常方便。
 */
public class Client {
	public static void main(String[] args) {
		Cache<Integer, Object> cache = new FIFOCache<>(10, 1000);
		cache.put(1, new Object());
		Object o = cache.get(1);
	}
}
