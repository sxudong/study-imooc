package com.payroll.transaction;

import com.payroll.payrollDomain.Affiliation;
import com.payroll.payrollImpl.NoAffiliation;
import com.payroll.payrollImpl.UnionAffiliation;
import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionImpl.AddHourlyEmployee;
import com.payroll.transactionImpl.ChangeMemberTransaction;
import com.payroll.transactionImpl.ChangeUnaffiliatedTransaction;
import org.junit.Assert;
import org.junit.Test;

public class ChangeUnaffiliatedTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
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
        Assert.assertEquals(charge, ((UnionAffiliation) af).getDues(), 0.01);

        ChangeUnaffiliatedTransaction cut = new ChangeUnaffiliatedTransaction(empId);
        cut.execute();

        Affiliation af2 = employee.getAffiliation();
        Assert.assertNotNull(af2);
        Assert.assertTrue(af2 instanceof NoAffiliation);

        Employee member = PayrollDatabase.getUnionMember(memberId);
        Assert.assertNull(member);
    }
}
