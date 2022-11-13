package com.hibernate.annotation.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

/**
 * 会员卡：与会员是多对一的关系
 * 
 * @author sean
 * 
 */
@Entity
@Table(name = "member_card", uniqueConstraints = { @UniqueConstraint(columnNames = "card_no") })
public class MemberCard implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "card_no", length = 20, nullable = false)
	private String cardNo;

	@ManyToOne
	@JoinColumn(name = "member_id", referencedColumnName="id")
	private Member member;

	public MemberCard() {
	}

	public MemberCard(Integer id, String cardNo, Member member) {
		super();
		this.id = id;
		this.cardNo = cardNo;
		this.member = member;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 获取卡编号
	 * 
	 * @return
	 */
	public String getCardNo() {
		return cardNo;
	}

	/**
	 * 设置卡编号
	 * 
	 * @param cardNo
	 */
	public void setCardNo(String cardNo) {
		this.cardNo = cardNo;
	}

	/**
	 * 获取卡所属的会员
	 * 
	 * @return
	 */
	public Member getMember() {
		return member;
	}

	/**
	 * 设置卡所属的会员
	 * 
	 * @param member
	 */
	public void setMember(Member member) {
		this.member = member;
	}

}
