package chapter19;

/**
 * 租赁 顾客租了某个影片
 **/
public class Rental {
    private Movie _movie;
    private int _daysRented;

    public Rental(Movie movie, int daysRented) {
        _movie = movie;
        _daysRented = daysRented;
    }

    public Movie getMovie() {
        return _movie;
    }

    public int getDaysRented() {
        return _daysRented;
    }

    /**
     * 金额计算
     * 1. 找出逻辑泥团并运用Extract Method
     **/
    double getCharge() {
        return _movie.getCharge(_daysRented);
    }

    /**
     * 常客积分计算
     **/
    public int getFrequentRenterPoints() {
        return _movie.getFrequentRenterPoints(_daysRented);
    }
}
