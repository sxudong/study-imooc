package chapter6;

import chapter6.source.Order;

import java.util.Enumeration;

/**
 * 提取方法
 */
public class _1_Extract_Method {

    private String _name = "";
    Order orders = new Order(0);

    public _1_Extract_Method(String name) {
        this._name = name;
    }

    void printOwing(double previousAmount) {
        printBanner();
        double outstanding = getOutstanding(previousAmount * 1.2);
        printDetail(outstanding);
    }

    private double getOutstanding(double result) {
        Enumeration e = orders.elements();
        while (e.hasMoreElements()) {
            Order each = (Order) e.nextElement();
            result += each.getAmount();
        }
        return result;
    }

    private void printBanner() {
        System.out.println("*************************");
        System.out.println("***** Customer Owes *****");
        System.out.println("*************************");
    }

    private void printDetail(double outstanding) {
        System.out.println("name:" + _name);
        System.out.println("amount:" + outstanding);
    }

//    public static void main(String[] args) {
//        _1_Extract_Method em = new _1_Extract_Method("thisName");
//        em.printOwing(11);
//    }
}
