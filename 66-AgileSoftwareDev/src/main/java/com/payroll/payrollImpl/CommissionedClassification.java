package com.payroll.payrollImpl;

import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.util.DateUtil;
import com.payroll.util.Paycheck;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 支付类别 : 底薪 + 提成支付
 */
public class CommissionedClassification extends PaymentClassification {

    /** 底薪 */
    private double salary;
    /** 提成比例 */
    private double commissionRate;

    private Map<Date, SalesReceipt> salesReceipts;

    public CommissionedClassification(double salary, double commissionRate) {
        this.salary = salary;
        this.commissionRate = commissionRate;
        salesReceipts = new HashMap<>();
    }

    @Override
    public double calculatePay(Paycheck paycheck) {
        double salesAmount = 0;
        for(SalesReceipt salesReceipt : salesReceipts.values()){
            if(DateUtil.isInPayPeriod(salesReceipt.getDate(), paycheck)){
                salesAmount += salesReceipt.getAmount();
            }
        }
        return salary + salesAmount * commissionRate;
    }

    public void addSalesReceipt(SalesReceipt salesReceipt){
        salesReceipts.put(salesReceipt.getDate(), salesReceipt);
    }

    public SalesReceipt getSalesReceipt(Date date) {
        return salesReceipts.get(date);
    }

    public double getSalary() {
        return salary;
    }

    public double getCommissionRate() {
        return commissionRate;
    }
}
