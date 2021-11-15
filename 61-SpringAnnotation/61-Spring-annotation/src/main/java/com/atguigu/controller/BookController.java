package com.atguigu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.atguigu.service.BookService;

/**
 * 配置类：config/MainConifgOfAutowired
 * 单元测试类：IOCTest_Autowired
 */
@Controller
public class BookController {
	
	@Autowired
	private BookService bookService;

}
