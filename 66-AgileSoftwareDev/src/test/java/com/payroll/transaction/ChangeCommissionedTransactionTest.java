package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.CommissionedClassification;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollImpl.BiweeklySchedule;
import com.payroll.transactionImpl.AddHourlyEmployee;
import com.payroll.transactionImpl.ChangeCommissionedTransaction;
import org.junit.Assert;
import org.junit.Test;

public class ChangeCommissionedTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute();

        double salary = 1000.00;
        double commissionRate = 88.8;
        ChangeCommissionedTransaction cct = new ChangeCommissionedTransaction(empId, salary, commissionRate);
        cct.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        PaymentClassification pcf = employee.getItsClassification();
        Assert.assertNotNull(pcf);
        Assert.assertTrue(pcf instanceof CommissionedClassification);
        Assert.assertEquals(salary, ((CommissionedClassification) pcf).getSalary(), 0.01);
        Assert.assertEquals(commissionRate, ((CommissionedClassification) pcf).getCommissionRate(), 0.01);
        Assert.assertTrue(employee.getItsPaymentSchedule() instanceof BiweeklySchedule);
    }
}
