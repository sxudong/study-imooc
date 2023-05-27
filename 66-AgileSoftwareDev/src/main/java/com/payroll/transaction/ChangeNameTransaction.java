package com.payroll.transaction;

import com.payroll.emp.Employee;

public class ChangeNameTransaction extends ChangeEmployeeTransaction {

    private String newName;

    public ChangeNameTransaction(int empId, String newName) {
        super(empId);
        this.newName = newName;
    }

    @Override
    protected void change(Employee employee) {
        employee.setEmpName(newName);
    }
}
