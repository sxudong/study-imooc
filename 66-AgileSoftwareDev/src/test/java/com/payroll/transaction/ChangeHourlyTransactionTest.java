package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;
import com.payroll.paymentClassification.HourlyClassification;
import com.payroll.paymentClassification.PaymentClassification;
import com.payroll.paymentSchedule.WeeklySchedule;
import org.junit.Assert;
import org.junit.Test;

public class ChangeHourlyTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double salary = 1000.00;
        double commissionRate = 88.8;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, name, address, salary, commissionRate);
        commissionedEmployee.execute();

        ChangeHourlyTransaction cht = new ChangeHourlyTransaction(empId, 27.5);
        cht.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        PaymentClassification pcf = employee.getPaymentClassification();
        Assert.assertNotNull(pcf);
        Assert.assertTrue(pcf instanceof HourlyClassification);
        Assert.assertEquals(27.5, ((HourlyClassification) pcf).getHourlyRate(), 0.01);
        Assert.assertTrue(employee.getPaymentSchedule() instanceof WeeklySchedule);
    }
}
