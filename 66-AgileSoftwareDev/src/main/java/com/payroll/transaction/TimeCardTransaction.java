package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;
import com.payroll.paymentClassification.HourlyClassification;
import com.payroll.paymentClassification.TimeCard;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Date;

@AllArgsConstructor
public class TimeCardTransaction implements Transaction{

    @Getter
    private Date date;

    private double hours;

    private int empId;

    @Override
    public void execute() {
        Employee employee = PayrollDatabase.getEmployee(empId);
        if(null == employee){
            throw new RuntimeException("No such employee");
        }
        HourlyClassification hc = (HourlyClassification) employee.getPaymentClassification();
        hc.addTimeCard(new TimeCard(date, hours));
    }
}
