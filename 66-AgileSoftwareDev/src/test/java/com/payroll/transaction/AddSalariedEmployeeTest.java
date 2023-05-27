package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;
import com.payroll.paymentClassification.SalariedClassification;
import com.payroll.paymentMethod.HoldMethod;
import com.payroll.paymentSchedule.MonthlySchedule;
import org.junit.Assert;
import org.junit.Test;


public class AddSalariedEmployeeTest extends BaseTest {

    @Test
    public void addTest() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        AddSalariedEmployee addSalariedEmployee = new AddSalariedEmployee(empId, name, address, 1000.0D);
        addSalariedEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Assert.assertTrue(employee.getPaymentClassification() instanceof SalariedClassification);
        Assert.assertEquals(1000.00, ((SalariedClassification) employee.getPaymentClassification()).getSalary(), 0.01);
        Assert.assertTrue(employee.getPaymentSchedule() instanceof MonthlySchedule);
        Assert.assertTrue(employee.getPaymentMethod() instanceof HoldMethod);
    }

}
