package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.CommissionedClassification;
import com.payroll.payrollImpl.HoldMethod;
import com.payroll.payrollImpl.BiweeklySchedule;
import com.payroll.transactionImpl.AddCommissionedEmployee;
import org.junit.Assert;
import org.junit.Test;


public class AddCommissionedEmployeeTest extends BaseTest {

    @Test
    public void addTest() {
        int empId = 1;
        double salary = 1000.00;
        double commissionRate = 88.8;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Assert.assertTrue(employee.getItsClassification() instanceof CommissionedClassification);
        Assert.assertEquals(salary, ((CommissionedClassification) employee.getItsClassification()).getSalary(), 0.01D);
        Assert.assertEquals(commissionRate, ((CommissionedClassification) employee.getItsClassification()).getCommissionRate(), 0.01D);
        Assert.assertTrue(employee.getItsPaymentSchedule() instanceof BiweeklySchedule);
        Assert.assertTrue(employee.getItsPaymentMethod() instanceof HoldMethod);
    }

}
