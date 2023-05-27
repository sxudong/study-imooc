package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;
import com.payroll.paymentClassification.HourlyClassification;
import com.payroll.paymentClassification.TimeCard;
import org.junit.Assert;
import org.junit.Test;

import java.util.Date;

public class TimeCardTransactionTest extends BaseTest {

    @Test
    public void timeCardTest() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        Date today = new Date();
        double hours = 8.25;
        TimeCardTransaction tct = new TimeCardTransaction(today, hours, empId);
        tct.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        Assert.assertTrue(employee.getPaymentClassification() instanceof HourlyClassification);
        TimeCard tc = ((HourlyClassification) employee.getPaymentClassification()).getTimeCard(today);
        Assert.assertNotNull(tc);
        Assert.assertEquals(hours, tc.getHours(), 0.01D);
    }

}
