package chapter19;

public class ChildrendsPrice extends Price {
    @Override
    int getPriceCode() {
        return Movie.CHILDRENS;
    }

    @Override
    double getCharge(int daysRented) {
        double result = 1.5;
        if(daysRented > 3) {
            result += (daysRented -3) * 1.5;
        }
        return result;
    }
}
