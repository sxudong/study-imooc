package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;
import com.payroll.paymentClassification.CommissionedClassification;
import com.payroll.paymentClassification.SalesReceipt;
import lombok.AllArgsConstructor;

import java.util.Date;

@AllArgsConstructor
public class SalesReceiptTransaction implements Transaction{

    private Date date;

    private double amount;

    private int empId;

    @Override
    public void execute() {
        Employee employee = PayrollDatabase.getEmployee(empId);
        if(null == employee){
            throw new RuntimeException("No such employee");
        }
        CommissionedClassification cc = (CommissionedClassification) employee.getPaymentClassification();
        cc.addSalesReceipt(new SalesReceipt(date, amount));
    }
}
