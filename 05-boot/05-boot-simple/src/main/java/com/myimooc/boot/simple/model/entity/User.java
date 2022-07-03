package com.myimooc.boot.simple.model.entity;

import java.util.ArrayList;
import java.util.List;

public class User {
    private String id;
    private String username;
    private String mobile;
    private String companyName;
    private String departmentName;

    public User(String id, String username, String mobile, String companyName, String departmentName) {
        this.id = id;
        this.username = username;
        this.mobile = mobile;
        this.companyName = companyName;
        this.departmentName = departmentName;
    }
    // 创建 JavaBean
    public static List<User> getUserList() throws Exception {
        List<User> list = new ArrayList<>();
        for (int i = 1; i <= 5; i++) {
            User user = new User(i + "", "testName" + i, "10" + i, "企业" + i, "部门" + i);
            list.add(user);
        }
        return list;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}
