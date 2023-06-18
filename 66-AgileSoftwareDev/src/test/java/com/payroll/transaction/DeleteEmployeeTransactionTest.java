package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionImpl.AddSalariedEmployee;
import com.payroll.transactionImpl.DeleteEmployeeTransaction;
import org.junit.Assert;
import org.junit.Test;

/**
 * 程序19.12 testDeleteEmployee P189
 */
public class DeleteEmployeeTransactionTest {
    PayrollDatabase payrollDatabase = new PayrollDatabase();

    @Test
    public void testDeleteEmployee(){
        Integer id = 4;
        double monthlyPay = 1000;
        AddSalariedEmployee addSalariedEmployee = new AddSalariedEmployee(id,"Bob4","Bob4.home",monthlyPay);
        addSalariedEmployee.execute();
        Employee e = payrollDatabase.getEmployee(id);
        Assert.assertEquals("Bob4", e.getItsName());

        DeleteEmployeeTransaction deleteEmployeeTransaction = new DeleteEmployeeTransaction(id);
        deleteEmployeeTransaction.execute();
        Assert.assertNull(payrollDatabase.getEmployee(id));
    }
}
