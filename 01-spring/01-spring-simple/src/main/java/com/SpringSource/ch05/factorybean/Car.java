package com.SpringSource.ch05.factorybean;

/**
 * 《Spring源码深度解析》5.1 FactoryBean的使用 P83
 *  Car的每一个属性分别对应一个<property>元素标签
 */
public class Car {

    private int maxSpeed;
    private String brand;
    private double price;

    public int getMaxSpeed() {
        return maxSpeed;
    }

    public void setMaxSpeed(int maxSpeed) {
        this.maxSpeed = maxSpeed;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
