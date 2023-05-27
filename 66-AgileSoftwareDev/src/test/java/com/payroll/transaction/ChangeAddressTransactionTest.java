package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;
import org.junit.Assert;
import org.junit.Test;

public class ChangeAddressTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        String newAddress = "School";
        ChangeAddressTransaction ct = new ChangeAddressTransaction(empId, newAddress);
        ct.execute();
        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        Assert.assertEquals(newAddress, employee.getEmpAddress());

    }
}
