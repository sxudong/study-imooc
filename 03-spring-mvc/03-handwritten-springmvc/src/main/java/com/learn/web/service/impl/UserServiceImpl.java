package com.learn.web.service.impl;

import com.learn.annotation.MyService;
import com.learn.web.service.UserService;


@MyService("userService")
public class UserServiceImpl implements UserService {
    @Override
    public String get(String name) {
        return "查询到姓名为：" + name;
    }
}
