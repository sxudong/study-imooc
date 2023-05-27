package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;

public abstract class ChangeEmployeeTransaction implements Transaction{

    private int empId;

    protected ChangeEmployeeTransaction(int empId) {
        this.empId = empId;
    }

    @Override
    public void execute() {
        Employee employee = PayrollDatabase.getEmployee(empId);
        if(null != employee){
            change(employee);
        }
    }


    protected abstract void change(Employee employee);
}
