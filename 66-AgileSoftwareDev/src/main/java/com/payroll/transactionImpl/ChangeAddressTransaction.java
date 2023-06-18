package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeEmployeeTransaction;
import com.payroll.payrollDomain.Employee;

public class ChangeAddressTransaction extends ChangeEmployeeTransaction {

    private String newAddress;

    public ChangeAddressTransaction(int empId, String newAddress) {
        super(empId);
        this.newAddress = newAddress;
    }

    @Override
    protected void change(Employee employee) {
        employee.setItsAddress(newAddress);
    }
}