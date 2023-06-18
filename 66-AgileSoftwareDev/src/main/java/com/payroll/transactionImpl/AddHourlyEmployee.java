package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.AddEmployeeTransaction;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollDomain.PaymentSchedule;
import com.payroll.payrollImpl.PayrollFactoryImpl;

/**
 * 添加按钟点工
 */
public class AddHourlyEmployee extends AddEmployeeTransaction {

    /** 时薪 */
    private double hourlyRate;

    public AddHourlyEmployee(int empId, String empName, String empAddress, double hourlyRate) {
        super(empId, empName, empAddress);
        this.hourlyRate = hourlyRate;
    }

    @Override
    protected PaymentSchedule getPaymentSchedule() {
        //return new WeeklySchedule(); // 每周五支付薪水
        return PayrollFactoryImpl.getInstance().makeWeeklySchedule();
    }

    @Override
    protected PaymentClassification getPaymentClassification() {
        //return new HourlyClassification(hourlyRate);
        return PayrollFactoryImpl.getInstance().makeHourlyClassification(hourlyRate);
    }
}
