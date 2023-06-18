package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionImpl.AddHourlyEmployee;
import com.payroll.transactionImpl.ChangeAddressTransaction;
import org.junit.Assert;
import org.junit.Test;

public class ChangeAddressTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute();

        String newAddress = "School";
        ChangeAddressTransaction ct = new ChangeAddressTransaction(empId, newAddress);
        ct.execute();
        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        Assert.assertEquals(newAddress, employee.getItsAddress());

    }
}
