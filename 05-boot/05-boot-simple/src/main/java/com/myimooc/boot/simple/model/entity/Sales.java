package com.myimooc.boot.simple.model.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Sales {
    /**
     * 主键ID
     */
    @Id
    @GeneratedValue
    private Integer id;

    private String area;

    private String seller;

    private Integer sales;

    private Integer apple;

    private Integer orange;

    private Integer milk;

    public Sales(){

    }

    public Sales(Integer id, String area, String seller, Integer sales, Integer apple, Integer orange, Integer milk) {
        this.id = id;
        this.area = area;
        this.seller = seller;
        this.sales = sales;
        this.apple = apple;
        this.orange = orange;
        this.milk = milk;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getSeller() {
        return seller;
    }

    public void setSeller(String seller) {
        this.seller = seller;
    }

    public Integer getSales() {
        return sales;
    }

    public void setSales(Integer sales) {
        this.sales = sales;
    }

    public Integer getApple() {
        return apple;
    }

    public void setApple(Integer apple) {
        this.apple = apple;
    }

    public Integer getOrange() {
        return orange;
    }

    public void setOrange(Integer orange) {
        this.orange = orange;
    }

    public Integer getMilk() {
        return milk;
    }

    public void setMilk(Integer milk) {
        this.milk = milk;
    }

}
