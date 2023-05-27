package com.payroll.emp;

import com.payroll.affiliation.Affiliation;
import com.payroll.affiliation.NoAffiliation;
import com.payroll.paymentClassification.PaymentClassification;
import com.payroll.paymentMethod.PaymentMethod;
import com.payroll.paymentSchedule.PaymentSchedule;
import com.payroll.util.Paycheck;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
public class Employee {

    private int empId;
    private String empName;
    private String empAddress;

    private PaymentMethod paymentMethod;
    private PaymentSchedule paymentSchedule;
    private PaymentClassification paymentClassification;

    private Affiliation affiliation = new NoAffiliation();

    public Employee(int empId, String empName, String empAddress) {
        this.empId = empId;
        this.empName = empName;
        this.empAddress = empAddress;
    }

    public void payDay(Paycheck pc){
        double grossPay = paymentClassification.calculatePay(pc);
        double deductions = affiliation.calculateDeductions(pc);
        double netPay = grossPay - deductions;

        pc.setGrossPay(grossPay);
        pc.setDeductions(deductions);
        pc.setNetPay(netPay);

        paymentMethod.pay(pc);
    }

    public boolean isPayDate(Date payDate) {
        return paymentSchedule.isPayDate(payDate);
    }

    public Date getPayPeriodStartDate(Date payPeriodEndDate){
        return paymentSchedule.getPayPeriodStartDate(payPeriodEndDate);
    }
}
