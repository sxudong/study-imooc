package com.SpringSourceAnalysis.ch08.jdbc.service;

import com.SpringSourceAnalysis.ch08.jdbc.pojo.User;

import java.util.List;

/**
 * 数据操作接口
 * 《Spring源码深度解析》P215
 */
public interface UserService {
    public void save (User user) ;
    public List<User> getUsers ();
    public Long queryCount();
}
