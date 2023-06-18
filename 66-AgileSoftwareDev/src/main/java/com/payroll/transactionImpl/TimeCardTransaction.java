package com.payroll.transactionImpl;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.HourlyClassification;
import com.payroll.transactionApplication.Transaction;

import java.util.Date;

/**
 * 程序19.14 时间卡 P192
 */
public class TimeCardTransaction implements Transaction {

    private Date date;
    private double hours;
    private int empId;

    public TimeCardTransaction(Date date, double hours, int empId) {
        this.date = date;
        this.hours = hours;
        this.empId = empId;
    }

    @Override
    public void execute() {
        Employee employee = PayrollDatabase.getEmployee(empId);
        if(null == employee){
            throw new RuntimeException("No such employee");
        }
        HourlyClassification hc = (HourlyClassification) employee.getItsClassification();
        // hc.addTimeCard(new TimeCard(date, hours));
        hc.addTimeCard(date, hours); // 为保护 TimeCard 的私有性对 TimeCardTransaction 做的修改 P249 图22.6
    }

    public Date getDate() {
        return date;
    }
}
