package com.learn.controller;

import com.learn.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;


@Controller
public class IndexController {

    @Autowired
    private UserService userService;

    /**
     * http://localhost:9090/index
     */
    @RequestMapping(value = "/index",produces = "text/html;charset=UTF-8")
    @ResponseBody
    public String index(){
        return "纯手写Java语言实现SpringBoot注解启动SpringMVC容器";
    }

    /**
     * 如果类上面用的是 @Controller，这里返回的就是一个 pageIndex.jsp 页面。如果是 @RestController，则返回字符。
     * http://localhost:9090/pageIndex
     */
    @RequestMapping("/pageIndex")
    public String pageIndex() {
        return "pageIndex";
    }

    /**
     * 如果类上面用的是 @Controller，这里返回的就是一个 springboot.jsp 页面。如果是 @RestController，则返回字符。
     * http://localhost:9090/index2
     */
    @RequestMapping(value = "/index2", produces = "text/html;charset=UTF-8")
    public String index2(Model model) {
        String str = userService.index();
        model.addAttribute("str",str); //返回到jsp页面显示数据
        return "springboot";
    }

    /**
     * http://localhost:9090/handle
     */
    @RequestMapping("/handle")
    public String handle01(Model model){
        Date date = new Date();
        model.addAttribute("date", date);
        return "success";
    }
}
