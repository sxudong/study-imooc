package com.example.test;
 
public class MessageBuilder {
    public String getMessage(String name) {
        StringBuilder result = new StringBuilder();
        if (name == null || name.trim().length() == 0) {
            result.append("empty!");
        } else {
            result.append("Hello " + name);
        }
        return result.toString();
    }
 
    public String getMessage1(String name) {
        StringBuilder result = new StringBuilder();
        if (name == "zhangsan") {
            result.append("zhangsan");
        } else {
            result.append("Hello " + name);
        }
        return result.toString();
    }
 
    public String getMessage2(String name) {
        StringBuilder result = new StringBuilder();
        if (name == "lisi") {
            result.append("lisi");
        } else {
            result.append("Hello " + name);
        }
        return result.toString();
    }
 
 
}