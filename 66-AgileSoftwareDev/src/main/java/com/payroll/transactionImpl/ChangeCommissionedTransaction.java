package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeClassificationTransaction;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollDomain.PaymentSchedule;
import com.payroll.payrollImpl.PayrollFactoryImpl;

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
        //return new CommissionedClassification(salary, commissionRate);
        return PayrollFactoryImpl.getInstance().makeCommissionedClassification(salary, commissionRate);
    }

    @Override
    protected PaymentSchedule getSchedule() {
        //return new BiweeklySchedule();
        return PayrollFactoryImpl.getInstance().makeBiweeklySchedule();
    }
}
