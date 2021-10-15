package com.atguigu.service;


import javax.annotation.Resource;
import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.atguigu.dao.BookDao;


@Service
public class BookService {
	
	//@Qualifier("bookDao")
	@Autowired(required=false) // false没有的情况下为null,不会报错
	//@Resource(name="bookDao2")
	//@Inject // 需要导入javax.inject的包,和Autowired的功能一样。没有required=false的功能；
	private BookDao bookDao; // 有多个bean根据名字导入


	// 如果一个接口有多个实现类时，通过注解获取实例时怎么知道应该获取的是哪一个实现类serviceImpl呢？
//	// 1) @Autowired 需要结合@Qualifier来使用，如下：
//	@Autowired
//	@Qualifier("bookDao2")
//	private BookDao bookDao;
//
//	// 2) @Resource可直接通过指定name属性的值即可
//	@Resource(name = "bookDao2")
//	private BookDao bookDao;
//
//	// 2) @Resource如果不显示的指定name值，就会自动把实例变量的名称作为name的值的，所以也可以直接这样写：
//	@Resource
//	private BookDao bookDao2;

	public void print(){
		System.out.println(bookDao);
	}

	@Override
	public String toString() {
		return "BookService [bookDao=" + bookDao + "]";
	}
	

}
