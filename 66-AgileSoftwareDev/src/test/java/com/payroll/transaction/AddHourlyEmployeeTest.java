package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.HourlyClassification;
import com.payroll.payrollImpl.HoldMethod;
import com.payroll.payrollImpl.WeeklySchedule;
import com.payroll.transactionImpl.AddHourlyEmployee;
import org.junit.Assert;
import org.junit.Test;


public class AddHourlyEmployeeTest extends BaseTest {

    @Test
    public void addTest() {
        int empId = 1;
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Assert.assertTrue(employee.getItsClassification() instanceof HourlyClassification);
        Assert.assertEquals(hourlyRate, ((HourlyClassification) employee.getItsClassification()).getHourlyRate(), 0.01D);
        Assert.assertTrue(employee.getItsPaymentSchedule() instanceof WeeklySchedule);
        Assert.assertTrue(employee.getItsPaymentMethod() instanceof HoldMethod);
    }

}
