package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeClassificationTransaction;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollImpl.SalariedClassification;
import com.payroll.payrollImpl.MonthlySchedule;
import com.payroll.payrollDomain.PaymentSchedule;

/**
 * P203
 */
public class ChangeSalariedTransaction extends ChangeClassificationTransaction {

    private double salary;

    public ChangeSalariedTransaction(int empId, double salary) {
        super(empId);
        this.salary = salary;
    }

    @Override
    protected PaymentClassification getClassification() {
        return new SalariedClassification(salary);
    }

    @Override
    protected PaymentSchedule getSchedule() {
        return new MonthlySchedule();
    }
}
