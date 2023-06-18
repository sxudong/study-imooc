package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeMethodTransaction;
import com.payroll.payrollImpl.MailMethod;
import com.payroll.payrollDomain.PaymentMethod;

public class ChangeMailTransaction extends ChangeMethodTransaction {

    public ChangeMailTransaction(int empId) {
        super(empId);
    }

    @Override
    protected PaymentMethod getMethod() {
        return new MailMethod();
    }
}
