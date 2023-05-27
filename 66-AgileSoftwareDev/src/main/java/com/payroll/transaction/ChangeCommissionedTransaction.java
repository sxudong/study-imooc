package com.payroll.transaction;

import com.payroll.paymentClassification.CommissionedClassification;
import com.payroll.paymentClassification.PaymentClassification;
import com.payroll.paymentSchedule.BiweeklySchedule;
import com.payroll.paymentSchedule.PaymentSchedule;

public class ChangeCommissionedTransaction extends ChangeClassificationTransaction{

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
