package com.payroll.payrollDomain;

import com.payroll.util.Paycheck;

/**
 * 支付方式
 */
public interface PaymentMethod {
    void pay(Paycheck pc);
}
