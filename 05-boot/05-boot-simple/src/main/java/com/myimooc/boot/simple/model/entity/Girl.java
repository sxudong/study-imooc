package com.myimooc.boot.simple.model.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

/**
 * 实体
 *
 * JPA 会自动建表
 * CREATE TABLE `girl`(
 *   `id` int (11) NOT NULL,
 *   `age` int (11) DEFAULT NULL,
 *   `cup_size` varchar (255) DEFAULT NULL,
 *   PRIMARY KEY (`id`)
 * )ENGINE=InnoDB DEFAULT CHARSET=utf8;
 *
 * @author zc 2017-02-18
 */
@Entity
public class Girl {

    /**
     * 主键ID
     */
    @Id
    @GeneratedValue
    private Integer id;
    /**
     * 大小
     */
    private String cupSize;
    /**
     * 年龄
     */
    private Integer age;

    public Girl() {
    }

    @Override
    public String toString() {
        return "Girl{" +
                "id=" + id +
                ", cupSize='" + cupSize + '\'' +
                ", age=" + age +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCupSize() {
        return cupSize;
    }

    public void setCupSize(String cupSize) {
        this.cupSize = cupSize;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }
}
