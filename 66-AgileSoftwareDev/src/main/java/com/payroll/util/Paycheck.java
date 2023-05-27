package com.payroll.util;

import lombok.Data;

import java.util.Date;

@Data
public class Paycheck {

    private double grossPay;

    private double deductions;

    private String disposition;
    
    private double netPay;

    private Date payPeriodStartDate;

    private Date payPeriodEndDate;

    public Paycheck(Date payPeriodStartDate, Date payPeriodEndDate) {
        this.payPeriodStartDate = payPeriodStartDate;
        this.payPeriodEndDate = payPeriodEndDate;
    }
}
