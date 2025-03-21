package com.SpringSourceAnalysis.ch11.mvc;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

/**
 * SimpleUrlHandlerMapping 示例在: study-imooc/03-first-springmvc
 */
@RestController
public class UserController {

    @RequestMapping(value = "/user", method = RequestMethod.GET)
    public ModelAndView userList() {
        List<User> userList = new ArrayList<>();
        userList.add(new User("张三", 27));
        userList.add(new User("李四", 28));
        return new ModelAndView("userlist", "users", userList);
    }

}
