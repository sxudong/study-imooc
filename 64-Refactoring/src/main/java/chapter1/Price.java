package chapter1;

/**
 * 价格
 **/
public abstract class Price {
    /**
     * 获取类型
     * 1. 找出逻辑泥团并运用 Extract Method
     *    Alt+Shift+M Extract Method
     * 2. 函数应该放在它使用的数据所属对象内
     *    Alt+Shift+V Move Method
     **/
    abstract int getPriceCode();

    /**
     * 金额计算
     **/
    abstract double getCharge(int daysRented);

    /**
     * 常客积分计算
     * 运用多态取代与价格相关的条件逻辑
     **/
    public int getFrequentRenterPoints(int daysRented) {
        return 1;
    }
}
