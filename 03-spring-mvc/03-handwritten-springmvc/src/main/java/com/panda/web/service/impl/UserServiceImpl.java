package com.panda.web.service.impl;

import com.panda.annotation.MyService;
import com.panda.entity.User;
import com.panda.web.service.UserService;

import java.util.List;


@MyService("userService")
public class UserServiceImpl implements UserService {
    @Override
    public String get(String name) {
        return "查询到姓名为：" + name;
    }
}
