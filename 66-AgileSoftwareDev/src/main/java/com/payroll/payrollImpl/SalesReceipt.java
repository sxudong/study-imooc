package com.payroll.payrollImpl;

import java.util.Date;

/**
 * 销售凭条
 */
public class SalesReceipt {
    private Date date;
    /** 销售金额 */
    private double amount;

    public SalesReceipt(Date date, double amount) {
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
