package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import lombok.AllArgsConstructor;

/**
 * 删除雇员
 */
@AllArgsConstructor
public class DeleteEmployeeTransaction implements Transaction {

    private int empId;

    @Override
    public void execute() {
        PayrollDatabase.deleteEmploy(empId);
    }
}
