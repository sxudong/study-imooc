package com.myimooc.boot.simple.model.entity;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Saless {

    private Integer id;

    private String area;

    private String seller;

    private Integer sales;

    private Integer apple;

    private Integer orange;

    private Integer milk;

    public Saless(){
    }

    public Saless(Integer id, String area, String seller, Integer sales, Integer apple, Integer orange, Integer milk) {
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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Saless saless = (Saless) o;
        return Objects.equals(id, saless.id) && Objects.equals(area, saless.area) && Objects.equals(seller, saless.seller) && Objects.equals(sales, saless.sales) && Objects.equals(apple, saless.apple) && Objects.equals(orange, saless.orange) && Objects.equals(milk, saless.milk);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, area, seller, sales, apple, orange, milk);
    }

    @Override
    public String toString() {
        return "Saless{" +
                "id=" + id +
                ", area='" + area + '\'' +
                ", seller='" + seller + '\'' +
                ", sales=" + sales +
                ", apple=" + apple +
                ", orange=" + orange +
                ", milk=" + milk +
                '}';
    }
}
