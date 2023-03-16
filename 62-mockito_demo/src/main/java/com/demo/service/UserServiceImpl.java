package com.demo.service;

import com.demo.dao.JdbcQueryManager;
import com.demo.model.PageParam;
import com.demo.model.User;
import com.demo.model.UserDTO;

import java.util.*;

public class UserServiceImpl {

    private JdbcQueryManager jdbcQueryManager;

    private int pleaseTest(int a, int b) {
        return a * 2 + b;
    }

    public User findById(Long id) {
        User user = new User(id);

        ArrayList<User> list = new ArrayList<>();
        list.add(user);
        list.add(new User(1L));
        list.add(new User(2L));

        Optional<User> u = list.stream().filter(i -> i.getId() == 9527L).findFirst();
        System.out.println("ID: " + user.getId());
        return jdbcQueryManager.queryForObject(user, User.class).orElse(null);
    }

    public List<User> findByName(long pageNo, long pageSize, String name) {
        User user = new User();
        user.setName(name);
        PageParam page = PageParam.create(pageNo, pageSize);
        return jdbcQueryManager.queryForPageList(user, User.class, page);
    }

    public List<UserDTO> findByUser(User user) {
        return jdbcQueryManager.queryForList(user, User.class, User::convert);
    }

    public List<Map<String, Object>> findByNameAndIdCard(String name, String idCard) {
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("idCard", idCard);
        return jdbcQueryManager.queryForMap(map);
    }

    public UserDTO testStatic(User user) {
        return User.convert(user);
    }

    public String testPrivateMethod(String str) {
        return privateMethod(str);
    }

    public String testStaticMethodMethod(String str) {
        return staticMethod(str);
    }

    private String privateMethod(String str) {
        return "I am private method. " + str;
    }

    private static String staticMethod(String str) {
        return "I am static method. " + str;
    }
}
