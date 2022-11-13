package com.hibernate.annotation.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.UniqueConstraint;

import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Parameter;

/**
 * stockDetail: 与stock是一对一的关系 
 * 
 * @author Administrator
 *
 */
@Entity
@Table(name = "stock_detail", uniqueConstraints = { @UniqueConstraint(columnNames = "comp_name") })
public class StockDetail implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "stock_id")
	@GenericGenerator(name = "generator", strategy = "foreign", parameters = @Parameter(name = "property", value = "stock"))
	@GeneratedValue(generator = "generator")
	private Integer stockId;

	@OneToOne
	@PrimaryKeyJoinColumn
	private Stock stock;

	@Column(name = "comp_name", length = 20, nullable = false)
	private String compName;

	@Column(name = "comp_desc", length = 200)
	private String compDesc;

	@Column(name = "remark", length = 255)
	private String remark;

	@Temporal(TemporalType.DATE)
	@Column(name = "listed_date", length = 10)
	private Date listedDate;

	public StockDetail() {
	}

	public StockDetail(Integer stockId, Stock stock, String compName,
			String compDesc, String remark, Date listedDate) {
		super();
		this.stockId = stockId;
		this.stock = stock;
		this.compName = compName;
		this.compDesc = compDesc;
		this.remark = remark;
		this.listedDate = listedDate;
	}

	public Integer getStockId() {
		return stockId;
	}

	public void setStockId(Integer stockId) {
		this.stockId = stockId;
	}

	public Stock getStock() {
		return stock;
	}

	public void setStock(Stock stock) {
		this.stock = stock;
	}

	public String getCompName() {
		return compName;
	}

	public void setCompName(String compName) {
		this.compName = compName;
	}

	public String getCompDesc() {
		return compDesc;
	}

	public void setCompDesc(String compDesc) {
		this.compDesc = compDesc;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Date getListedDate() {
		return listedDate;
	}

	public void setListedDate(Date listedDate) {
		this.listedDate = listedDate;
	}

}
