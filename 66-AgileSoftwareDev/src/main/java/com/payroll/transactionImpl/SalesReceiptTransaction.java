package com.payroll.transactionImpl;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.CommissionedClassification;
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
        //cc.addSalesReceipt(new SalesReceipt(date, amount));
        cc.addSalesReceipt(date, amount); // 为保护 SalesReceipt 的私有性对 SalesReceiptTransaction 做的修改 P249 图22.6
    }
}
