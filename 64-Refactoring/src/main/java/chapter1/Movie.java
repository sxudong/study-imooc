package chapter1;

/**
 * 影片
 **/
public class Movie {
    public static final int CHILDRENS = 2;
    public static final int REGULAR = 0;
    public static final int NEW_RELEASE = 1;

    private String _title;
    private Price _price;

    public Movie(String title, int priceCode) {
        _title = title;
        setPriceCode(priceCode);
    }

    public String getTitle() {
        return _title;
    }

    public void setTitle(String title) {
        this._title = title;
    }

    public int getPriceCode() {
        return _price.getPriceCode();
    }

    public void setPriceCode(int arg) {
        switch (arg) {
            case REGULAR:
                _price = new RegularPrice();
                break;
            case CHILDRENS:
                _price = new ChildrendsPrice();
                break;
            case NEW_RELEASE:
                _price = new NewReleasePrice();
                break;
            default:
                throw new IllegalArgumentException("Incorrect Price Code!");
        }
    }

    /**
     * 金额计算
     * 1. 找出逻辑泥团并运用Extract Method
     *    Alt+Shift+M Extract Method
     * 2. 函数应该放在它使用的数据所属对象内
     *    Alt+Shift+V Move Method
     **/
    double getCharge(int daysRented) {
        return _price.getCharge(daysRented);
    }

    /**
     * 常客积分计算
     * 运用多态取代与价格相关的条件逻辑
     **/
    public int getFrequentRenterPoints(int daysRented) {
        return _price.getFrequentRenterPoints(daysRented);
    }
}
