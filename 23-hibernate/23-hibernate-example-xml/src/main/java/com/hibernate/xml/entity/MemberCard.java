package com.hibernate.xml.entity;

import java.io.Serializable;

/**
 * 会员卡：与会员是多对一的关系
 * 
 * @author sean
 * 
 */
public class MemberCard implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Integer id;

	private String cardNo;

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
