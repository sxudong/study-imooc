package chapter19;

public class NewReleasePrice extends Price {
    @Override
    int getPriceCode() {
        return Movie.NEW_RELEASE;
    }


    @Override
    double getCharge(int daysRented) {
        return daysRented*3;
    }

    @Override
    public int getFrequentRenterPoints(int daysRented) {
        return (daysRented > 1)? 2 : 1;
    }
}
