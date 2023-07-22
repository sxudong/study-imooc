package chapter19.ver01;

/**
 * 影片 实体类
 */
public class Movie {
	/**
	 * 儿童影片
	 */
	public static final int CHILDRENS = 2;
	/**
	 * 普通影片
	 */
	public static final int REGULAR = 0;
	/**
	 * 新影片
	 */
	public static final int NEW_RELEASE = 1;
	/**
	 * 影片名称
	 */
	private String _title;
	/**
	 * 影片价格
	 */
	private int _priceCode;

	public Movie(String title, int priceCode) {
		_title = title;
		_priceCode = priceCode;
	}

	public int getPriceCode() {
		return _priceCode;
	}

	public String getTitle() {
		return _title;
	}

	public void setPriceCode(int priceCode) {
		_priceCode = priceCode;
	}

}