package com.hibernate.annotation.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;

/**
 * stock: 与stockDetail是一对一的关系
 * 
 * @author Administrator
 *
 */
@Entity
@Table(name = "stock", uniqueConstraints = {
		@UniqueConstraint(columnNames = "stock_code"),
		@UniqueConstraint(columnNames = "stock_name") })
public class Stock implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "stock_id", unique = true, nullable = false)
	private Integer stockId;

	@OneToOne(mappedBy = "stock")
	@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE })
	private StockDetail stockDetail;

	@Column(name = "stock_code", length = 10, nullable = false)
	private String stockCode;

	@Column(name = "stock_name", length = 20, nullable = false)
	private String stockName;

	public Stock() {
	}

	public Stock(Integer stockId, StockDetail stockDetail, String stockCode,
			String stockName) {
		super();
		this.stockId = stockId;
		this.stockDetail = stockDetail;
		this.stockCode = stockCode;
		this.stockName = stockName;
	}

	public Integer getStockId() {
		return stockId;
	}

	public void setStockId(Integer stockId) {
		this.stockId = stockId;
	}

	public String getStockCode() {
		return stockCode;
	}

	public void setStockCode(String stockCode) {
		this.stockCode = stockCode;
	}

	public String getStockName() {
		return stockName;
	}

	public void setStockName(String stockName) {
		this.stockName = stockName;
	}

	public StockDetail getStockDetail() {
		return stockDetail;
	}

	public void setStockDetail(StockDetail stockDetail) {
		this.stockDetail = stockDetail;
	}

}
