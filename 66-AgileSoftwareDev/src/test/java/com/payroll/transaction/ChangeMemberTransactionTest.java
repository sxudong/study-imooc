package com.payroll.transaction;

import com.payroll.payrollDomain.Affiliation;
import com.payroll.payrollImpl.UnionAffiliation;
import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionImpl.AddHourlyEmployee;
import com.payroll.transactionImpl.ChangeMemberTransaction;
import org.junit.Assert;
import org.junit.Test;

/**
 * 程序19.29  P204
 * 它创建了一个名为 Bill 钟点雇员，然后创建并执行一个 ChangeMemberTransaction 把 Bill 放入协会中。
 * 接着核实 Bill 绑定了一个 UnionAffiliation 对象，而且该 UnionAffiliation 对象具有正确的会费。
 */
public class ChangeMemberTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bill", "Home", hourlyRate);
        hourlyEmployee.execute();

        int memberId = 1000;
        double charge = 88.8;
        ChangeMemberTransaction cmt = new ChangeMemberTransaction(empId, memberId, charge);
        cmt.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);

        Affiliation af = employee.getAffiliation();
        Assert.assertNotNull(af);
        Assert.assertTrue(af instanceof UnionAffiliation);
        Assert.assertEquals(88.8, ((UnionAffiliation) af).getDues(), 0.01);

        Employee member = PayrollDatabase.getUnionMember(memberId);
        Assert.assertNotNull(member);
        Assert.assertTrue(employee == member);
    }
}
