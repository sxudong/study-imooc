package com.hibernate.annotation.entity;

import java.util.Date;
import java.util.List;

import org.hibernate.Query;

import com.hibernate.annotation.BaseTest;

public class OneToOneTest extends BaseTest {

	private String stockName = "张三";

	/**
	 * test add
	 */
	public void testAdd() {
		logger.debug("test add");
		saveStockAndDetail();
	}

	/**
	 * test update
	 */
	@SuppressWarnings("unchecked")
	public void testUpdate() {

		logger.debug("test update");
		// 准备数据
		saveStockAndDetail();
		tx.commit();

		// 级联更新
		tx = session.beginTransaction();
		Query query = session.createQuery("from Stock where stockName=?")
				.setString(0, stockName);
		List<Stock> stocks = query.list();
		Stock stock = stocks.get(0);
		StockDetail stockDetail = stock.getStockDetail();
		stock.setStockCode("2014-01-08");
		stockDetail.setCompName("修改公司名称");
		session.update(stock);
	}

	/**
	 * test delete
	 */
	@SuppressWarnings("unchecked")
	public void testDelete() {

		logger.debug("test update");
		// 准备数据
		saveStockAndDetail();
		tx.commit();
		
		// 级联删除
		tx = session.beginTransaction();
		Query query = session.createQuery("from Stock where stockName=?")
				.setString(0, stockName);
		List<Stock> stocks = query.list();
		Stock stock = stocks.get(0);
		session.delete(stock);
	}

	private void saveStockAndDetail() {
		StockDetail stockDetail = new StockDetail();
		stockDetail.setCompDesc("无线搜索专家");
		stockDetail.setCompName("深圳市宜搜科技发展有限公司");
		stockDetail.setListedDate(new Date());
		stockDetail.setRemark("新的一年向游戏领域进军");

		Stock stock = new Stock();
		stock.setStockCode("2014-01-07");
		stock.setStockName(stockName);
		stock.setStockDetail(stockDetail);
		stockDetail.setStock(stock);

		session.save(stock);

	}

	/**
	 * clear data: 测试之前清楚数据，使每一个测试用例都是独立的，不相互影响。
	 */
	@Override
	public void clearData() {

		logger.debug("clear data");

		tx = session.beginTransaction();
		Query query = session.createQuery("delete from StockDetail");
		query.executeUpdate();
		query = session.createQuery("delete from Stock");
		query.executeUpdate();
		tx.commit();
	}
}
