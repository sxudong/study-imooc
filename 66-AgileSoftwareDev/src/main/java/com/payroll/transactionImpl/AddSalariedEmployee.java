package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.AddEmployeeTransaction;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollImpl.SalariedClassification;
import com.payroll.payrollImpl.MonthlySchedule;
import com.payroll.payrollDomain.PaymentSchedule;

/**
 * 添加月度发薪雇员
 */
public class AddSalariedEmployee extends AddEmployeeTransaction {

    /** 月薪 */
    private double salary;

    public AddSalariedEmployee(int empId, String empName, String empAddress, double salary) {
        super(empId, empName, empAddress);
        this.salary = salary;
    }

    @Override
    protected PaymentSchedule getPaymentSchedule() {
        return new MonthlySchedule();
    }

    @Override
    protected PaymentClassification getPaymentClassification() {
        return new SalariedClassification(salary);
    }
}
