package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.AddEmployeeTransaction;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollDomain.PaymentSchedule;
import com.payroll.payrollImpl.PayrollFactoryImpl;

/**
 * 添加带提成的雇员
 */
public class AddCommissionedEmployee extends AddEmployeeTransaction {

    /** 底薪 */
    private double salary;
    /** 提成比例 */
    private double commissionRate;

    public AddCommissionedEmployee(int empId, String empName, String empAddress, double salary, double commissionRate) {
        super(empId, empName, empAddress);
        this.salary = salary;
        this.commissionRate = commissionRate;
    }

    @Override
    protected PaymentSchedule getPaymentSchedule() {
        //return new BiweeklySchedule(); // 每两周一次支付
        return PayrollFactoryImpl.getInstance().makeBiweeklySchedule(); // 每两周一次支付
    }

    @Override
    protected PaymentClassification getPaymentClassification() {
        //return new CommissionedClassification(salary, commissionRate);
        return PayrollFactoryImpl.getInstance().makeCommissionedClassification(salary, commissionRate);
    }
}
