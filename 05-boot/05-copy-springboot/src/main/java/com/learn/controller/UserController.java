package com.learn.controller;

import com.learn.pojo.MyBean;
import com.learn.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.Date;

/**
 * @Auther: 洺润Star
 * @Date: 2020/5/1 19:02
 * @Description:
 */
@RestController //默认添加@ResponseBody
public class UserController {
    @Autowired
    private UserService userService;

    /**
     * http://localhost:9090/user
     */
    @RequestMapping(value = "/user", produces = "text/html;charset=UTF-8")
    public String user() {
        return userService.index();
    }

    /**
     * http://localhost:9090/sayHello?age=17&name=张三
     */
    @RequestMapping("sayHello")
    @ResponseBody
    public ModelAndView sayHello(int age, String name) {
        ModelAndView mav = new ModelAndView();
        MyBean bean = new MyBean(age, name);
        mav.addObject("myBean", bean);
        mav.setViewName("sayHello");
        System.out.println(bean.toString());
        return mav;
    }
}

