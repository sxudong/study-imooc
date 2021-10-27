package com.SpringSource.ch06.test;

public class Dog {
    private String name;
    private Integer age;

    public Dog(String name, Integer age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public void sayHello(){
        System.out.println("大家好，我叫" + name + ", 我今年" + age +"岁了");
    }
}
