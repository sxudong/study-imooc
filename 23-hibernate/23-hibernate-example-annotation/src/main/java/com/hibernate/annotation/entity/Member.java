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
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;

/**
 * 会员：与会员卡是一对多的关系
 * 
 * @author sean
 * 
 */
@Entity
@Table(name = "member", uniqueConstraints = { @UniqueConstraint(columnNames = "member_name") })
public class Member implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "member_name", length = 20, nullable = false)
	private String memberName;

	@OneToMany(mappedBy = "member", fetch = FetchType.LAZY)
	@Cascade({ CascadeType.SAVE_UPDATE, CascadeType.DELETE })
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
