package com.myimooc.spring.simple.aop.aspectj.biz;

import com.myimooc.spring.simple.aop.aspectj.MoocMethod;
import org.springframework.stereotype.Service;


@Service
public class MoocBiz {

	@MoocMethod("MoocBiz save with MoocMethod.")
	public String save(String arg) {
		System.out.println("MoocBiz save : " + arg);
		//throw new RuntimeException(" Save failed!");
		return " Save success!";
	}

}
