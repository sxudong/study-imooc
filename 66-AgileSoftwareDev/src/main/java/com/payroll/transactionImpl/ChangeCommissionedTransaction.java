package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeClassificationTransaction;
import com.payroll.payrollImpl.CommissionedClassification;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollImpl.BiweeklySchedule;
import com.payroll.payrollDomain.PaymentSchedule;

/**
 * P203
 */
public class ChangeCommissionedTransaction extends ChangeClassificationTransaction {

    private double salary;
    private double commissionRate;

    public ChangeCommissionedTransaction(int empId, double salary, double commissionRate) {
        super(empId);
        this.salary = salary;
        this.commissionRate = commissionRate;
    }

    @Override
    protected PaymentClassification getClassification() {
        return new CommissionedClassification(salary, commissionRate);
    }

    @Override
    protected PaymentSchedule getSchedule() {
        return new BiweeklySchedule();
    }
}
