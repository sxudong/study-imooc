package com.payroll.transactionImpl;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.CommissionedClassification;
import com.payroll.payrollImpl.SalesReceipt;
import com.payroll.transactionApplication.Transaction;

import java.util.Date;

public class SalesReceiptTransaction implements Transaction {

    private Date date;
    private double amount;
    private int empId;

    public SalesReceiptTransaction(Date date, double amount, int empId) {
        this.date = date;
        this.amount = amount;
        this.empId = empId;
    }

    @Override
    public void execute() {
        Employee employee = PayrollDatabase.getEmployee(empId);
        if(null == employee){
            throw new RuntimeException("No such employee");
        }
        CommissionedClassification cc = (CommissionedClassification) employee.getItsClassification();
        cc.addSalesReceipt(new SalesReceipt(date, amount));
    }
}
