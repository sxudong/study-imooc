package com.hibernate.xml.entity;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.hibernate.Query;

import com.hibernate.xml.BaseTest;

public class OneToManyTest extends BaseTest {

	private String memberName = "张三";

	/**
	 * test add
	 */
	public void testAdd() {
		logger.debug("test add");
		saveMemberAndCard();
	}

	/**
	 * test update
	 */
	public void testUpdate() {

		logger.debug("test update");

		// 准备数据
		saveMemberAndCard();
		tx.commit();
		// 清楚session缓存，观察懒加载
		session.clear();

		// 级联更新
		tx = session.beginTransaction();
		@SuppressWarnings("unchecked")
		List<Member> members = session
				.createQuery("from Member where memberName=?")
				.setString(0, memberName).list();
		Member member = members.get(0);
		member.setMemberName("修改会员名称");

		Set<MemberCard> cards = member.getMemberCards();
		MemberCard card = cards.iterator().next();
		card.setCardNo("9876543210");

		session.update(member);
	}

	/**
	 * test delete
	 */
	public void testDelete() {

		logger.debug("test delete");
		// 准备数据
		saveMemberAndCard();
		tx.commit();
		session.clear();

		// 没有采用级联删除策略，所以先删除依赖，再删除自己。
		tx = session.beginTransaction();
		@SuppressWarnings("unchecked")
		List<Member> members = session
				.createQuery("from Member where memberName=?")
				.setString(0, memberName).list();
		Member member = members.get(0);

		// error
		// session.delete(member);

		// first delete cards
		Set<MemberCard> cards = member.getMemberCards();
		for (MemberCard card : cards) {
			session.delete(card);
		}
		// second delete member
		session.delete(member);

	}

	@Override
	protected void clearData() {
		tx = session.beginTransaction();
		Query query = session.createQuery("delete from MemberCard");
		query.executeUpdate();
		query = session.createQuery("delete from Member");
		query.executeUpdate();
		tx.commit();
	}

	private void saveMemberAndCard() {

		Member member = new Member();
		member.setMemberName(memberName);

		Set<MemberCard> memberCards = new HashSet<MemberCard>();
		MemberCard card1 = new MemberCard();
		card1.setCardNo("1234567890");
		MemberCard card2 = new MemberCard();
		card2.setCardNo("1234567891");
		MemberCard card3 = new MemberCard();
		card3.setCardNo("1234567892");
		card1.setMember(member);
		card2.setMember(member);
		card3.setMember(member);

		memberCards.add(card1);
		memberCards.add(card2);
		memberCards.add(card3);

		member.setMemberCards(memberCards);
		session.save(member);
	}
}
