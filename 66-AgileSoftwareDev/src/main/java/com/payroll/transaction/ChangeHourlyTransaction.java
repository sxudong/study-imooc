package com.payroll.transaction;

import com.payroll.paymentClassification.HourlyClassification;
import com.payroll.paymentClassification.PaymentClassification;
import com.payroll.paymentSchedule.PaymentSchedule;
import com.payroll.paymentSchedule.WeeklySchedule;


public class ChangeHourlyTransaction extends ChangeClassificationTransaction {

    private double hourlyRate;


    public ChangeHourlyTransaction(int empId, double hourlyRate) {
        super(empId);
        this.hourlyRate = hourlyRate;
    }

    @Override
    protected PaymentClassification getClassification() {
        return new HourlyClassification(hourlyRate);
    }

    @Override
    protected PaymentSchedule getSchedule() {
        return new WeeklySchedule();
    }
}
