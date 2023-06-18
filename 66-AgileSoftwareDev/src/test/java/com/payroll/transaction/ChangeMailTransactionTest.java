package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.HoldMethod;
import com.payroll.payrollImpl.MailMethod;
import com.payroll.payrollDomain.PaymentMethod;
import com.payroll.transactionImpl.AddCommissionedEmployee;
import com.payroll.transactionImpl.ChangeMailTransaction;
import org.junit.Assert;
import org.junit.Test;

public class ChangeMailTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        double salary = 1000.00;
        double commissionRate = 88.8;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        employee.setItsPaymentMethod(new HoldMethod());

        ChangeMailTransaction cmt = new ChangeMailTransaction(empId);
        cmt.execute();

        PaymentMethod pm = employee.getItsPaymentMethod();
        Assert.assertNotNull(pm);
        Assert.assertTrue(pm instanceof MailMethod);
    }
}
