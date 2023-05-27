package com.payroll.paymentMethod;

import com.payroll.util.Paycheck;

/**
 * 直接存入银行账户
 */
public class DirectMethod implements PaymentMethod {

    @Override
    public void pay(Paycheck pc) {
        pc.setDisposition("Direct");
    }
}
