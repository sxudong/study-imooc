package com.panda.web.controller;

import com.panda.annotation.MyAutowired;
import com.panda.annotation.MyController;
import com.panda.annotation.MyRequestMapping;
import com.panda.annotation.MyRequestParam;
import com.panda.web.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 手写 SpringMVC 框架源码
 *
 * @Date 2019/10/25 14:15
 * https://blog.csdn.net/u011432354/article/details/102780273
 **/
@MyController
public class UserController {

    @MyAutowired
    private UserService userService;


    /**
     *  控制台打印信息的时候，出行中文乱码问题：
     *  在 Run/Debug Configurations VM options 设置 -Dfile.encoding=UTF-8 编码方式
     *
     *  http://localhost:8080/springmvc/index?name=张三
     */
    @MyRequestMapping("/index")
    public String index(HttpServletRequest request, HttpServletResponse response,
                        @MyRequestParam("name") String name) throws IOException {
        String res = userService.get(name);
        System.out.println(name + "=>" + res);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(res);
        return "index";
    }
}
/* Output:
init...
========第一步:扫描文件包==========
保存类名：com.panda.web.controller.UserController
保存类名：com.panda.web.service.impl.UserServiceImpl
保存类名：com.panda.web.service.UserService
========第二步:IOC==========
IOC名称：userController:com.panda.web.controller.UserController@76053a4
IOC名称：com.panda.web.service.UserService:com.panda.web.service.impl.UserServiceImpl@46eb2062
IOC名称：userService:com.panda.web.service.impl.UserServiceImpl@46eb2062
mapped:/index=>public java.lang.String com.panda.web.controller.UserController.index(javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,java.lang.String) throws java.io.IOException
张三=>查询到姓名为：张三
 */