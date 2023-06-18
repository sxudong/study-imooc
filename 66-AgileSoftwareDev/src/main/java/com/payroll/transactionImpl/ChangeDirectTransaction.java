package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeMethodTransaction;
import com.payroll.payrollDomain.PaymentMethod;
import com.payroll.payrollImpl.PayrollFactoryImpl;

public class ChangeDirectTransaction extends ChangeMethodTransaction {

    public ChangeDirectTransaction(int empId) {
        super(empId);
    }

    @Override
    protected PaymentMethod getMethod() {
        //return new DirectMethod();
        return PayrollFactoryImpl.getInstance().makeDirectMethod();
    }
}
