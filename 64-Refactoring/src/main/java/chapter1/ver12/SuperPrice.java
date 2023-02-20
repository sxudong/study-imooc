package chapter1.ver12;

public class SuperPrice extends Price {
    int getPriceCode() {
        return Movie.SUPER;
    }

    public double getCharge(int daysRented) {
        return daysRented * 4;
    }

    public int getFrequentRenterPoints(int daysRented) {
        return 3;
    }
}
