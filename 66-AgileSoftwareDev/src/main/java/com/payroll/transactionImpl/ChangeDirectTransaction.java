package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeMethodTransaction;
import com.payroll.payrollImpl.DirectMethod;
import com.payroll.payrollDomain.PaymentMethod;

public class ChangeDirectTransaction extends ChangeMethodTransaction {

    public ChangeDirectTransaction(int empId) {
        super(empId);
    }

    @Override
    protected PaymentMethod getMethod() {
        return new DirectMethod();
    }
}
