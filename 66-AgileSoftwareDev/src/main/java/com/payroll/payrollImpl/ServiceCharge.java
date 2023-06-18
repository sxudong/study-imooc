package com.payroll.payrollImpl;

import java.util.Date;

/**
 * 服务费用记录
 */
public class ServiceCharge {
    private Date date;
    private double amount;

    public ServiceCharge(Date date, double amount) {
        this.date = date;
        this.amount = amount;
    }

    public Date getDate() {
        return date;
    }

    public double getAmount() {
        return amount;
    }
}
