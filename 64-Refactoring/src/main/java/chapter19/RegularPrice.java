package chapter19;

public class RegularPrice extends Price {
    @Override
    int getPriceCode() {
        return Movie.REGULAR;
    }

    @Override
    double getCharge(int daysRented) {
        double result = 2;
        if(daysRented > 2) {
            result += (daysRented -2) *1.5;
        }
        return result;
    }
}
