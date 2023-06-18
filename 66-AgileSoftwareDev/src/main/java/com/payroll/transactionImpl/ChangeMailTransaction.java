package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeMethodTransaction;
import com.payroll.payrollDomain.PaymentMethod;
import com.payroll.payrollImpl.PayrollFactoryImpl;

public class ChangeMailTransaction extends ChangeMethodTransaction {

    public ChangeMailTransaction(int empId) {
        super(empId);
    }

    @Override
    protected PaymentMethod getMethod() {
        //return new MailMethod();
        return PayrollFactoryImpl.getInstance().makeMailMethod();
    }
}
