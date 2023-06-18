package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeMethodTransaction;
import com.payroll.payrollDomain.PaymentMethod;
import com.payroll.payrollImpl.PayrollFactoryImpl;

public class ChangeHoldTransaction extends ChangeMethodTransaction {

    public ChangeHoldTransaction(int empId) {
        super(empId);
    }

    @Override
    protected PaymentMethod getMethod() {
        //return new HoldMethod();
        return PayrollFactoryImpl.getInstance().makeHoldMethod();
    }
}
