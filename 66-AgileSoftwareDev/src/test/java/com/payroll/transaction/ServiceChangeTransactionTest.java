package com.payroll.transaction;

import com.payroll.payrollImpl.ServiceCharge;
import com.payroll.payrollImpl.UnionAffiliation;
import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionImpl.AddHourlyEmployee;
import com.payroll.transactionImpl.ServiceChargeTransaction;
import org.junit.Assert;
import org.junit.Test;

import java.util.Date;

/**
 * 程序19.16 testAddServiceCharge P194
 */
public class ServiceChangeTransactionTest {

	PayrollDatabase payrollDatabase = new PayrollDatabase();

	@Test
	public void testAddServiceCharge() {
		int memberId = 1;
		int empId = 1;
		AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "张三", "上海", 10);
		hourlyEmployee.execute();
		Employee emp = payrollDatabase.getEmployee(empId);

		UnionAffiliation unionAffiliation = new UnionAffiliation(memberId, 100);
		emp.setAffiliation(unionAffiliation);
		payrollDatabase.addUnionMember(memberId, emp);

		ServiceChargeTransaction serviceChangeTransaction = new ServiceChargeTransaction(memberId, new Date("2018/5/19"), 100);
		serviceChangeTransaction.execute();

		ServiceCharge serviceCharge = unionAffiliation.getServiceCharge(new Date("2018/5/19"));
		Assert.assertNotNull(serviceCharge);
		Assert.assertEquals(100, serviceCharge.getAmount(), 0.01D);
	}
}