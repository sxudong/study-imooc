package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.CommissionedClassification;
import com.payroll.payrollImpl.SalesReceipt;
import com.payroll.transactionImpl.AddCommissionedEmployee;
import com.payroll.transactionImpl.SalesReceiptTransaction;
import org.junit.Assert;
import org.junit.Test;

import java.util.Date;

public class SalesReceiptTransactionTest extends BaseTest {

    @Test
    public void salesReceiptTest() {
        int empId = 1;
        double salary = 1000.00;
        double commissionRate = 88.8;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        Date today = new Date();
        double amount = 1884.25;
        SalesReceiptTransaction srt = new SalesReceiptTransaction(today, amount, empId);
        srt.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        Assert.assertTrue(employee.getItsClassification() instanceof CommissionedClassification);
        SalesReceipt sr = ((CommissionedClassification) employee.getItsClassification()).getSalesReceipt(today);
        Assert.assertNotNull(sr);
        Assert.assertEquals(amount, sr.getAmount(), 0.01D);
    }

}
