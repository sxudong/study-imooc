package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionImpl.AddHourlyEmployee;
import com.payroll.transactionImpl.ChangeNameTransaction;
import org.junit.Assert;
import org.junit.Test;

/**
 * 19.4 更改雇员属性  程序19.19  P196
 * 它使用 AddHourlyEmployee 操作创建了一个名为 Bill 的钟点雇员。接着，创建并执行了一个
 * ChangeNameTransaction 操作，该操作应该把雇员的名字更改为 Bob。最后，从 PayrollDatabase
 * 中取出该雇员实例并验证名字已经被更改。
 */
public class ChangeNameTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        double hourlyRate = 88.8;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bill", "Home", hourlyRate);
        hourlyEmployee.execute();

        ChangeNameTransaction ct = new ChangeNameTransaction(empId, "Bob");
        ct.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);
        Assert.assertEquals("Bob", employee.getItsName());
    }
}
