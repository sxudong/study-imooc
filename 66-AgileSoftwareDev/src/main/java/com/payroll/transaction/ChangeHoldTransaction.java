package com.payroll.transaction;

import com.payroll.paymentMethod.HoldMethod;
import com.payroll.paymentMethod.PaymentMethod;

public class ChangeHoldTransaction extends ChangeMethodTransaction{

    public ChangeHoldTransaction(int empId) {
        super(empId);
    }

    @Override
    public PaymentMethod getPaymentMethod() {
        return new HoldMethod();
    }
}
