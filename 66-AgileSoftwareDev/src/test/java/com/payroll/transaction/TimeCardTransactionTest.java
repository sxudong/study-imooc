package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.HourlyClassification;
import com.payroll.payrollImpl.TimeCard;
import com.payroll.transactionImpl.AddHourlyEmployee;
import com.payroll.transactionImpl.TimeCardTransaction;
import org.junit.Assert;
import org.junit.Test;

import java.util.Date;

/**
 * 程序19.12 testTimeCardTransaction P190
 */
public class TimeCardTransactionTest extends BaseTest {

    @Test
    public void timeCardTest() {
        int empId = 1;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", 15.25);
        hourlyEmployee.execute();

        TimeCardTransaction tct = new TimeCardTransaction(new Date("2023/05/23"), 8.25, empId);
        tct.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        Assert.assertTrue(employee.getItsClassification() instanceof HourlyClassification);

        TimeCard tc = ((HourlyClassification) employee.getItsClassification()).getTimeCard(new Date("2023/05/23"));
        Assert.assertNotNull(tc);
        Assert.assertEquals(8.25, tc.getHours(), 0.01D);
    }

}
