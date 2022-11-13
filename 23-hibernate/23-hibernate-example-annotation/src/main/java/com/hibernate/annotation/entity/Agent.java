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

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;

/**
 * 代理商：与客户是多对多的关系，中间实体AgentCustomer有除关系的额外字段
 * 
 * @author Administrator
 * 
 */
@Entity
@Table(name = "agent", uniqueConstraints = { @UniqueConstraint(columnNames = "agent_name") })
public class Agent implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "agent_name", length = 20, nullable = false)
	private String agentName;

	// orphanRemoval：级联删除孤立节点
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "pk.agent", orphanRemoval = true)
	@OrderBy("pk.customer asc")
	@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE })
	private Set<AgentCustomer> agentCustomers;

	public Agent() {
	}

	public Agent(Integer id, String agentName, Set<AgentCustomer> agentCustomers) {
		super();
		this.id = id;
		this.agentName = agentName;
		this.agentCustomers = agentCustomers;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getAgentName() {
		return agentName;
	}

	public void setAgentName(String agentName) {
		this.agentName = agentName;
	}

	public Set<AgentCustomer> getAgentCustomers() {
		return agentCustomers;
	}

	public void setAgentCustomers(Set<AgentCustomer> agentCustomers) {
		this.agentCustomers = agentCustomers;
	}

}
