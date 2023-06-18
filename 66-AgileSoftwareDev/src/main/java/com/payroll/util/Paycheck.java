package com.payroll.util;

import java.util.Date;

public class Paycheck {
    private Integer itsEmpId; // 工资总额
    private double grossPay; // 工资总额
    private double deductions; // 扣除
    private String disposition; // （财产、金钱的）处置，处置权
    private double netPay; // 实付工资
    private Date payPeriodStartDate; // 支付期间的起始日期（界限日期）
    private Date payPeriodEndDate;   // 支付期间的终止日期（界限日期）

    public Paycheck(Date payPeriodStartDate, Date payPeriodEndDate) {
        this.payPeriodStartDate = payPeriodStartDate;
        this.payPeriodEndDate = payPeriodEndDate;
    }

    public Integer getItsEmpId() {
        return itsEmpId;
    }

    public void setItsEmpId(Integer itsEmpId) {
        this.itsEmpId = itsEmpId;
    }

    public double getGrossPay() {
        return grossPay;
    }

    public void setGrossPay(double grossPay) {
        this.grossPay = grossPay;
    }

    public double getDeductions() {
        return deductions;
    }

    public void setDeductions(double deductions) {
        this.deductions = deductions;
    }

    public String getDisposition() {
        return disposition;
    }

    public void setDisposition(String disposition) {
        this.disposition = disposition;
    }

    public double getNetPay() {
        return netPay;
    }

    public void setNetPay(double netPay) {
        this.netPay = netPay;
    }

    public Date getPayPeriodStartDate() {
        return payPeriodStartDate;
    }

    public void setPayPeriodStartDate(Date payPeriodStartDate) {
        this.payPeriodStartDate = payPeriodStartDate;
    }

    public Date getPayPeriodEndDate() {
        return payPeriodEndDate;
    }

    public void setPayPeriodEndDate(Date payPeriodEndDate) {
        this.payPeriodEndDate = payPeriodEndDate;
    }
}
