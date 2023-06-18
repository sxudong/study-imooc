package com.payroll.transactionImpl;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.transactionApplication.Transaction;

/**
 * 19.2 删除雇员 P188
 * 这是一个典型的 Command 模式的实现
 */
public class DeleteEmployeeTransaction implements Transaction {

    private int empId;

    public DeleteEmployeeTransaction(int empId) {
        this.empId = empId;
    }

    @Override
    public void execute() {
        PayrollDatabase.deleteEmploy(empId);
    }
}
