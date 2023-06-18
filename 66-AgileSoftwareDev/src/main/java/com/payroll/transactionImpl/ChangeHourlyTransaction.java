package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeClassificationTransaction;
import com.payroll.payrollImpl.HourlyClassification;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollDomain.PaymentSchedule;
import com.payroll.payrollImpl.WeeklySchedule;

/**
 * 程序19.27 P202
 *    该类实现了从 ChangeClassificationTransaction 继承的 getClassification() 和
 *    getSchedule() 方法，从而完善了 Template method 模式。它的 getClassification()
 *    方法返回一个新创建的 HourlyClassification 对象。它的 getSchedule() 方法返回一个
 *    新创建的 WeeklySchedule 对象。
 */
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
