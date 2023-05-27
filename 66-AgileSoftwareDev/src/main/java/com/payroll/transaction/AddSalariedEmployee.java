package com.payroll.transaction;

import com.payroll.paymentClassification.PaymentClassification;
import com.payroll.paymentClassification.SalariedClassification;
import com.payroll.paymentSchedule.MonthlySchedule;
import com.payroll.paymentSchedule.PaymentSchedule;

/**
 * 添加月度发薪雇员
 */
public class AddSalariedEmployee extends AddEmployeeTransaction {

    /**
     * 月薪
     */
    private double salary;

    public AddSalariedEmployee(int empId, String empName, String empAddress, double salary) {
        super(empId, empName, empAddress);
        this.salary = salary;
    }

    @Override
    PaymentSchedule getPaymentSchedule() {
        return new MonthlySchedule();
    }

    @Override
    PaymentClassification getPaymentClassification() {
        return new SalariedClassification(salary);
    }
}
