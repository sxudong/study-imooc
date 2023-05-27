package com.payroll.paymentClassification;

import com.payroll.util.Paycheck;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 支付类别 ：按月支付
 */
@AllArgsConstructor
@Getter
public class SalariedClassification extends PaymentClassification{

    private double salary;


    @Override
    public double calculatePay(Paycheck paycheck) {
        return salary;
    }
}
