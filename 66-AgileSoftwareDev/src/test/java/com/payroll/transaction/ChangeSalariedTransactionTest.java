package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollImpl.SalariedClassification;
import com.payroll.payrollImpl.MonthlySchedule;
import com.payroll.transactionImpl.AddCommissionedEmployee;
import com.payroll.transactionImpl.ChangeSalariedTransaction;
import org.junit.Assert;
import org.junit.Test;

/**
 * P203
 */
public class ChangeSalariedTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        double salary = 1000.00;
        double commissionRate = 88.8;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        ChangeSalariedTransaction cst = new ChangeSalariedTransaction(empId, 500);
        cst.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);

        PaymentClassification pcf = employee.getItsClassification();
        Assert.assertNotNull(pcf);
        Assert.assertTrue(pcf instanceof SalariedClassification);
        Assert.assertEquals(500, ((SalariedClassification) pcf).getSalary(), 0.01);
        Assert.assertTrue(employee.getItsPaymentSchedule() instanceof MonthlySchedule);
    }
}
