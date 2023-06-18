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

public class AddServiceChargeTransactionTest extends BaseTest {

    @Test
    public void addTest() {
        int empId = 1;
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);

        int memberId = 20;
        double charge = 12.50;
        UnionAffiliation af = new UnionAffiliation(memberId, charge);

        employee.setAffiliation(af);
        PayrollDatabase.addUnionMember(memberId, employee);

        Date today = new Date();
        ServiceChargeTransaction sct = new ServiceChargeTransaction(memberId, today, charge);
        sct.execute();

        ServiceCharge sc = af.getServiceCharge(today);
        Assert.assertNotNull(sc);
        Assert.assertEquals(charge, sc.getAmount(), 0.01);
    }

}
