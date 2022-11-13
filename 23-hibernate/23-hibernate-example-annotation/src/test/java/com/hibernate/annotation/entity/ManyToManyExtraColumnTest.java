package com.hibernate.annotation.entity;

import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import junit.framework.Assert;

import org.hibernate.Query;

import com.hibernate.annotation.BaseTest;

/**
 * many-to-many：中间表有额外字段的测试
 * 
 * @author Administrator
 * 
 */
public class ManyToManyExtraColumnTest extends BaseTest {

	private String[] agentNames = { "agent1", "agent2", "agent3" };
	private String[] customerNames = { "customer1", "customer2", "customer3" };
	private String[] createdBys = { "createdBy1", "createdBy2", "createdBy3",
			"createdBy4", "createdBy5", "createdBy6" };

	/**
	 * test add
	 */
	public void testAdd() {
		logger.debug("test add");
		saveAgentAndCustomer();
	}

	/**
	 * test update
	 */
	@SuppressWarnings("unchecked")
	public void testUpdate() {

		logger.debug("test update");

		// 准备数据
		saveAgentAndCustomer();
		tx.commit();
		// 清楚session缓存，观察懒加载
		session.clear();

		// 级联更新: agent更新了名字，并同时去掉了一个agentCustomer。
		tx = session.beginTransaction();
		Agent agent = (Agent) session
				.createQuery("from Agent where agentName=?")
				.setString(0, agentNames[2]).list().get(0);
		agent.setAgentName(agentNames[2] + "1");
		Set<AgentCustomer> agentCustomers = agent.getAgentCustomers();
		Iterator<AgentCustomer> iterable = agentCustomers.iterator();
		AgentCustomer agentCustomer = iterable.next();
		AgentCustomer agentCustomer2 = iterable.next();
		agentCustomer2.setCreatedBy(createdBys[4] + "1");
		agentCustomers.remove(agentCustomer);
		session.update(agent);

		// 验证AgentCustomer确实少了一条记录：数据准备中总共插入了6条记录。
		List<AgentCustomer> agentCustomers2 = session.createQuery(
				"from AgentCustomer").list();
		Assert.assertEquals(5, agentCustomers2.size());

	}

	/**
	 * test delete
	 */
	@SuppressWarnings("unchecked")
	public void testDelete() {

		logger.debug("test delete");
		// 准备数据
		saveAgentAndCustomer();
		tx.commit();
		session.clear();

		// 级联删除
		tx = session.beginTransaction();
		// 这样执行语句无法级联删除。
		// Query query = session.createQuery("delete from Agent");
		// query.executeUpdate();

		// 只有通过delete方法才能实现级联操作。连同删除关系表中的数据，但是不影响customer表。
		List<Agent> agents = session.createQuery("from Agent").list();
		for (Agent agent : agents) {
			session.delete(agent);
		}
	}

	@Override
	protected void clearData() {
		tx = session.beginTransaction();
		Query query = session.createQuery("delete from AgentCustomer");
		query.executeUpdate();
		query = session.createQuery("delete from Agent");
		query.executeUpdate();
		query = session.createQuery("delete from Customer");
		query.executeUpdate();
		tx.commit();
	}

	private void saveAgentAndCustomer() {
		Agent agent1 = new Agent();
		Agent agent2 = new Agent();
		Agent agent3 = new Agent();
		agent1.setAgentName(agentNames[0]);
		agent2.setAgentName(agentNames[1]);
		agent3.setAgentName(agentNames[2]);

		Customer customer1 = new Customer();
		Customer customer2 = new Customer();
		Customer customer3 = new Customer();
		customer1.setCustomerName(customerNames[0]);
		customer2.setCustomerName(customerNames[1]);
		customer3.setCustomerName(customerNames[2]);
		// Agent只负责级联AgentCustomer，Customer得自己保存
		session.save(customer1);
		session.save(customer2);
		session.save(customer3);

		Date now = new Date();
		AgentCustomer agentCustomer1 = new AgentCustomer(new AgentCustomerId(
				agent1, customer1), now, createdBys[0]);
		AgentCustomer agentCustomer2 = new AgentCustomer(new AgentCustomerId(
				agent2, customer1), now, createdBys[1]);
		AgentCustomer agentCustomer3 = new AgentCustomer(new AgentCustomerId(
				agent2, customer2), now, createdBys[2]);
		AgentCustomer agentCustomer4 = new AgentCustomer(new AgentCustomerId(
				agent3, customer1), now, createdBys[3]);
		AgentCustomer agentCustomer5 = new AgentCustomer(new AgentCustomerId(
				agent3, customer2), now, createdBys[4]);
		AgentCustomer agentCustomer6 = new AgentCustomer(new AgentCustomerId(
				agent3, customer3), now, createdBys[5]);
		Set<AgentCustomer> agentCustomers1 = new HashSet<AgentCustomer>();
		Set<AgentCustomer> agentCustomers2 = new HashSet<AgentCustomer>();
		Set<AgentCustomer> agentCustomers3 = new HashSet<AgentCustomer>();
		agentCustomers1.add(agentCustomer1);
		agentCustomers2.add(agentCustomer2);
		agentCustomers2.add(agentCustomer3);
		agentCustomers3.add(agentCustomer4);
		agentCustomers3.add(agentCustomer5);
		agentCustomers3.add(agentCustomer6);

		agent1.setAgentCustomers(agentCustomers1);
		agent2.setAgentCustomers(agentCustomers2);
		agent3.setAgentCustomers(agentCustomers3);

		session.save(agent1);
		session.save(agent2);
		session.save(agent3);
	}
}
