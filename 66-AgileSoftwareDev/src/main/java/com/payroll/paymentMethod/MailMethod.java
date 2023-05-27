package com.payroll.paymentMethod;

import com.payroll.util.Paycheck;

/**
 * 支票邮寄
 */
public class MailMethod implements PaymentMethod {

    @Override
    public void pay(Paycheck pc) {
        pc.setDisposition("Mail");
    }
}
