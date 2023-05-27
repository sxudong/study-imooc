package com.payroll.transaction;

import com.payroll.paymentClassification.CommissionedClassification;
import com.payroll.paymentClassification.PaymentClassification;
import com.payroll.paymentSchedule.BiweeklySchedule;
import com.payroll.paymentSchedule.PaymentSchedule;

/**
 * 添加带提成的雇员
 */
public class AddCommissionedEmployee extends AddEmployeeTransaction {

    /**
     * 底薪
     */
    private double salary;

    /**
     * 提成比例
     */
    private double commissionRate;

    public AddCommissionedEmployee(int empId, String empName, String empAddress, double salary, double commissionRate) {
        super(empId, empName, empAddress);
        this.salary = salary;
        this.commissionRate = commissionRate;
    }

    @Override
    PaymentSchedule getPaymentSchedule() {
        return new BiweeklySchedule();
    }

    @Override
    PaymentClassification getPaymentClassification() {
        return new CommissionedClassification(salary, commissionRate);
    }
}
