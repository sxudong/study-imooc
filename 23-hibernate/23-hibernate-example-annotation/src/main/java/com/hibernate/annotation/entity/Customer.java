package com.hibernate.annotation.entity;

import java.io.Serializable;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * 客户：和代理商是多对多的关系，中间实体AgentCustomer有除关系的额外字段
 * 
 * @author Administrator
 * 
 */
@Entity
@Table(name = "customer", uniqueConstraints = { @UniqueConstraint(columnNames = "customer_name") })
public class Customer implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "customer_name", nullable = false, length = 20)
	private String customerName;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "pk.customer")
	@OrderBy("pk.agent asc")
	private Set<AgentCustomer> agentCustomers;

	public Customer() {
	}

	public Customer(Integer id, String customerName,
			Set<AgentCustomer> agentCustomers) {
		super();
		this.id = id;
		this.customerName = customerName;
		this.agentCustomers = agentCustomers;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public Set<AgentCustomer> getAgentCustomers() {
		return agentCustomers;
	}

	public void setAgentCustomers(Set<AgentCustomer> agentCustomers) {
		this.agentCustomers = agentCustomers;
	}

}
