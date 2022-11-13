package com.hibernate.xml.entity;

import java.io.Serializable;
import java.util.Set;

/**
 * 会员：与会员卡是一对多的关系
 * 
 * @author sean
 * 
 */
public class Member implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Integer id;

	private String memberName;

	private Set<MemberCard> memberCards;

	public Member() {
	}

	public Member(Integer id, String memberName, Set<MemberCard> memberCards) {
		super();
		this.id = id;
		this.memberName = memberName;
		this.memberCards = memberCards;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	/**
	 * 获取会员名称
	 * 
	 * @return
	 */
	public String getMemberName() {
		return memberName;
	}

	/**
	 * 设置会员名称
	 * 
	 * @param memberName
	 */
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	/**
	 * 获取会员的会员卡集合
	 * 
	 * @return
	 */
	public Set<MemberCard> getMemberCards() {
		return memberCards;
	}

	/**
	 * 设置会员的会员卡集合
	 * 
	 * @param memberCards
	 */
	public void setMemberCards(Set<MemberCard> memberCards) {
		this.memberCards = memberCards;
	}
}
