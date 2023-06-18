package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeEmployeeTransaction;
import com.payroll.payrollDomain.Employee;

/**
 * 程序19.23 P200
 * Template method 模式的另一半
 */
public class ChangeNameTransaction extends ChangeEmployeeTransaction {

    private String newName;

    public ChangeNameTransaction(int empId, String newName) {
        super(empId);
        this.newName = newName;
    }

    @Override
    protected void change(Employee employee) {
        employee.setItsName(newName);
    }
}
