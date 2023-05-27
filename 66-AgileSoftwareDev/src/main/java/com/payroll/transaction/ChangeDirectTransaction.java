package com.payroll.transaction;

import com.payroll.paymentMethod.DirectMethod;
import com.payroll.paymentMethod.PaymentMethod;

public class ChangeDirectTransaction extends ChangeMethodTransaction{

    public ChangeDirectTransaction(int empId) {
        super(empId);
    }

    @Override
    public PaymentMethod getPaymentMethod() {
        return new DirectMethod();
    }
}
