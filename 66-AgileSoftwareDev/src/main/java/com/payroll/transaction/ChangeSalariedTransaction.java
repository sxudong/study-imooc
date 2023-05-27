package com.payroll.transaction;

import com.payroll.paymentClassification.PaymentClassification;
import com.payroll.paymentClassification.SalariedClassification;
import com.payroll.paymentSchedule.MonthlySchedule;
import com.payroll.paymentSchedule.PaymentSchedule;


public class ChangeSalariedTransaction extends ChangeClassificationTransaction{

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
