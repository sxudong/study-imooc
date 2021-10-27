package com.SpringSource.ch05.factorybean;

import org.springframework.beans.factory.FactoryBean;

/**
 * 《Spring源码深度解析》5.1 FactoryBean的使用 P83
 *
 * 当配置文件中 <bean> 的 class 属性配置的实现类 FactoryBean 时，通过getBean()方法
 * 返回的不是 FactoryBean 本身，而是 FactoryBean#getObject() 方法所返回的对象，相当
 * 于 FactoryBean#getObject() 代理了getBean方法。
 */
public class CarFactoryBean implements FactoryBean<Car> {

    private String carInfo;

    @Override
    public Car getObject() throws Exception {
        Car car = new Car();
        String[] infos = carInfo.split(",");
        car.setBrand(infos[0]);
        car.setMaxSpeed(Integer.valueOf(infos[1]));
        car.setPrice(Double.valueOf(infos[2]));
        return car;
    }

    @Override
    public Class<?> getObjectType() {
        return Car.class;
    }

    @Override
    public boolean isSingleton() {
        return false;
    }

    public String getCarInfo() {
        return carInfo;
    }

    //接受逗号分割符设置属性信息
    public void setCarInfo(String carInfo) {
        this.carInfo = carInfo;
    }
}