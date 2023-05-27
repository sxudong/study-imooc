package com.payroll.transaction;

import com.payroll.paymentMethod.MailMethod;
import com.payroll.paymentMethod.PaymentMethod;

public class ChangeMailTransaction extends ChangeMethodTransaction {

    public ChangeMailTransaction(int empId) {
        super(empId);
    }

    @Override
    public PaymentMethod getPaymentMethod() {
        return new MailMethod();
    }
}
