package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeMethodTransaction;
import com.payroll.payrollImpl.HoldMethod;
import com.payroll.payrollDomain.PaymentMethod;

public class ChangeHoldTransaction extends ChangeMethodTransaction {

    public ChangeHoldTransaction(int empId) {
        super(empId);
    }

    @Override
    protected PaymentMethod getMethod() {
        return new HoldMethod();
    }
}
