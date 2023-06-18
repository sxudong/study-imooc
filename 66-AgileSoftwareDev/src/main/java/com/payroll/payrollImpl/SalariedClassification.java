package com.payroll.payrollImpl;

import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.util.Paycheck;

/**
 * 支付类别 ：按月支付
 */
public class SalariedClassification extends PaymentClassification {
    private double salary;

    public SalariedClassification(double salary) {
        this.salary = salary;
    }

    public double getSalary() {
        return salary;
    }

    @Override
    public double calculatePay(Paycheck paycheck) {
        return salary;
    }
}
