package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.SalariedClassification;
import com.payroll.payrollImpl.HoldMethod;
import com.payroll.payrollImpl.MonthlySchedule;
import com.payroll.transactionImpl.AddSalariedEmployee;
import org.junit.Assert;
import org.junit.Test;


public class AddSalariedEmployeeTest extends BaseTest {

    @Test
    public void addTest() {
        int empId = 1;
        AddSalariedEmployee addSalariedEmployee = new AddSalariedEmployee(empId, "Bob", "Home", 1000.0D);
        addSalariedEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Assert.assertTrue(employee.getItsClassification() instanceof SalariedClassification);
        Assert.assertEquals(1000.00, ((SalariedClassification) employee.getItsClassification()).getSalary(), 0.01);
        Assert.assertTrue(employee.getItsPaymentSchedule() instanceof MonthlySchedule);
        Assert.assertTrue(employee.getItsPaymentMethod() instanceof HoldMethod);
    }

}
