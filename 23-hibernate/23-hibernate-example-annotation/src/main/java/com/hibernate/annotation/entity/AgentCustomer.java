package com.hibernate.annotation.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.AssociationOverride;
import javax.persistence.AssociationOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 代理商与客户的中间关系实体
 * 
 * @author Administrator
 *
 */
@Entity
@Table(name = "agent_customer")
@AssociationOverrides({
		@AssociationOverride(name = "pk.agent", joinColumns = @JoinColumn(name = "agent_id")),
		@AssociationOverride(name = "pk.customer", joinColumns = @JoinColumn(name = "customer_id")) })
public class AgentCustomer implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@EmbeddedId
	private AgentCustomerId pk;

	@Temporal(TemporalType.DATE)
	@Column(name = "created_date", length = 10, nullable = false)
	private Date createdDate;
	@Column(name = "created_by", length = 20, nullable = false)
	private String createdBy;

	public AgentCustomer() {
	}

	public AgentCustomer(AgentCustomerId pk, Date createdDate, String createdBy) {
		super();
		this.pk = pk;
		this.createdDate = createdDate;
		this.createdBy = createdBy;
	}

	public AgentCustomerId getPk() {
		return pk;
	}

	public void setPk(AgentCustomerId pk) {
		this.pk = pk;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public String getCreatedBy() {
		return createdBy;
	}

	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}

	public Agent getAgent() {
		return getPk().getAgent();
	}

	public void setAgent(Agent agent) {
		getPk().setAgent(agent);
	}

	public Customer getCustomer() {
		return getPk().getCustomer();
	}

	public void setCustomer(Customer customer) {
		getPk().setCustomer(customer);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null || getClass() != obj.getClass()) {
			return false;
		}
		AgentCustomer that = (AgentCustomer) obj;
		if (getPk() != null ? !getPk().equals(that.getPk())
				: that.getPk() != null) {
			return false;
		}
		return true;
	}

	@Override
	public int hashCode() {
		return (getPk() != null ? getPk().hashCode() : 0);
	}
}
