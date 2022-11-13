package com.hibernate.annotation.entity;

import java.io.Serializable;

import javax.persistence.Embeddable;
import javax.persistence.ManyToOne;

/**
 * 复合主键
 * 
 * @author Administrator
 * 
 */
@Embeddable
public class AgentCustomerId implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@ManyToOne
	private Agent agent;
	@ManyToOne
	private Customer customer;

	public AgentCustomerId() {
	}

	public AgentCustomerId(Agent agent, Customer customer) {
		super();
		this.agent = agent;
		this.customer = customer;
	}

	public Agent getAgent() {
		return agent;
	}

	public void setAgent(Agent agent) {
		this.agent = agent;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null || getClass() != obj.getClass()) {
			return false;
		}
		AgentCustomerId that = (AgentCustomerId) obj;
		if (agent != null ? !agent.equals(that.agent) : that.agent != null) {
			return false;
		}
		if (customer != null ? !customer.equals(that.customer)
				: that.customer != null) {
			return false;
		}
		return true;
	}

	@Override
	public int hashCode() {
		int result;
		result = agent != null ? agent.hashCode() : 0;
		result = 31 * result + (customer != null ? customer.hashCode() : 0);
		return result;
	}
}
