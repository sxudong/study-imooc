package com.payroll.payrollDomain;

import com.payroll.payrollImpl.NoAffiliation;
import com.payroll.util.Paycheck;

import java.util.Date;

/**
 * 程序19.55 P219
 */
public class Employee {

    private int itsEmpId;
    private String itsName;
    private String itsAddress;

    // 策略类：itsClassification、itsAffiliation、itsPaymentMethod
    private PaymentMethod itsPaymentMethod; // 支付方法（银行卡/现金）
    private PaymentSchedule itsPaymentSchedule; // 判断一个日期是否为发薪日的算法依
    private PaymentClassification itsClassification; // CalculatePay 计算总工资算法

    private Affiliation itsAffiliation = new NoAffiliation(); // 非协会会员

    public Employee(int empId, String empName, String empAddress) {
        this.itsEmpId = empId;
        this.itsName = empName;
        this.itsAddress = empAddress;
    }

    public void payDay(Paycheck pc){
        double grossPay = itsClassification.calculatePay(pc); // 计算总工资
        double deductions = itsAffiliation.calculateDeductions(pc);  // 扣除额
        double netPay = grossPay - deductions; // 扣除税收和其他扣款后的实际工资

        pc.setGrossPay(grossPay);
        pc.setDeductions(deductions);
        pc.setNetPay(netPay);
        pc.setItsEmpId(this.itsEmpId);
        itsPaymentMethod.pay(pc);
    }

    public boolean isPayDate(Date payDate) {
        return itsPaymentSchedule.isPayDate(payDate);
    }

    public Date getPayPeriodStartDate(Date payPeriodEndDate){
        return itsPaymentSchedule.getPayPeriodStartDate(payPeriodEndDate);
    }

    public int getItsEmpId() {
        return itsEmpId;
    }

    public void setItsEmpId(int itsEmpId) {
        this.itsEmpId = itsEmpId;
    }

    public String getItsName() {
        return itsName;
    }

    public void setItsName(String itsName) {
        this.itsName = itsName;
    }

    public String getItsAddress() {
        return itsAddress;
    }

    public void setItsAddress(String itsAddress) {
        this.itsAddress = itsAddress;
    }

    public PaymentMethod getItsPaymentMethod() {
        return itsPaymentMethod;
    }

    public void setItsPaymentMethod(PaymentMethod itsPaymentMethod) {
        this.itsPaymentMethod = itsPaymentMethod;
    }

    public PaymentSchedule getItsPaymentSchedule() {
        return itsPaymentSchedule;
    }

    public void setItsPaymentSchedule(PaymentSchedule itsPaymentSchedule) {
        this.itsPaymentSchedule = itsPaymentSchedule;
    }

    public PaymentClassification getItsClassification() {
        return itsClassification;
    }

    public void setItsClassification(PaymentClassification itsClassification) {
        this.itsClassification = itsClassification;
    }

    public Affiliation getAffiliation() {
        return itsAffiliation;
    }

    public void setAffiliation(Affiliation itsAffiliation) {
        this.itsAffiliation = itsAffiliation;
    }
}
