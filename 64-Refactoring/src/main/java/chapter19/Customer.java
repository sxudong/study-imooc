package chapter19;

import java.util.Enumeration;
import java.util.Vector;

/**
 * 顾客  租用影片
 **/
public class Customer {
    private String _name;
    private Vector _rentals = new Vector();

    public Customer(String name) {
        _name = name;
    }
    public void addRental(Rental arg) {
        _rentals.addElement(arg);
    }

    public String getName() {
        return _name;
    }

    /**
     * 生成详单的函数。
     */
    public String statement(){
        Enumeration rentals = _rentals.elements();
        String result = "Rental Record For " + getName() + "\n";
        while (rentals.hasMoreElements()) {
            Rental each = (Rental)rentals.nextElement();

            // show figures for this rental
            // 找出多余的变量，使用 Replace Temp with Query : Alt + Shift + ,
            result += "\t" + each.getMovie().getTitle() + "\t" + String.valueOf(each.getCharge()) + "\n";
        }
        // add footer lines
        result += "Amount owed is " + String.valueOf(getTotalCharge()) + "\n";
        result += "You earned " + String.valueOf(getTotalFrequentRenterPoints()) + " frequent renter points";
        return result;
    }

    /**
     * 计算总常客积分
     * 临时变量助长冗长而复杂的函数，使用 Replace Temp with Query 和 Query Method
     **/
    private int getTotalFrequentRenterPoints() {
        int result = 0;
        Enumeration rentals = _rentals.elements();
        while (rentals.hasMoreElements()) {
            Rental rental = (Rental) rentals.nextElement();
            result += rental.getFrequentRenterPoints();
        }
        return result;
    }

    /**
     * 计算总金额
     * 临时变量助长冗长而复杂的函数，使用 Replace Temp with Query 和 Query Method
     **/
    private double getTotalCharge() {
        double result = 0;
        Enumeration rentals = _rentals.elements();
        while (rentals.hasMoreElements()) {
            Rental rental = (Rental) rentals.nextElement();
            result += rental.getCharge();
        }
        return result;
    }
}
