package com.payroll.payrollImpl;

import com.payroll.payrollDomain.Affiliation;
import com.payroll.util.DateUtil;
import com.payroll.util.Paycheck;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class UnionAffiliation implements Affiliation {

    private double charge;
    private int memberId;

    public double getDues() { // 会费，手续费
        return charge;
    }

    public int getMemberId() {
        return memberId;
    }

    private Map<Date, ServiceCharge> serviceCharges;

    public UnionAffiliation(int memberId, double charge) {
        this.memberId = memberId;
        this.charge = charge;
        this.serviceCharges = new HashMap<>();
    }

    public ServiceCharge getServiceCharge(Date date) {
        return serviceCharges.get(date);
    }

    public void addServiceCharge(Date date, double charge) {
        ServiceCharge sc = new ServiceCharge(date, charge);
        serviceCharges.put(date, sc);
    }

    /**
     * 程序19.50 P216
     */
    @Override
    public double calculateDeductions(Paycheck paycheck) {
        double deduce = charge * numberOfFridayInPayPeriod(paycheck.getPayPeriodStartDate(), paycheck.getPayPeriodEndDate());
        for (ServiceCharge serviceCharge : serviceCharges.values()) {
            if (DateUtil.isInPayPeriod(serviceCharge.getDate(), paycheck)) {
                deduce += serviceCharge.getAmount();
            }
        }
        return deduce;
    }

    // 从paycheck中获取支付期间的两个界限日期，然后把这两个日期传给一个计算它们之间周五数目的工具函数。
    // 接着，把计算接果乘以每周的会费就得到支付期间内的会费总额。
    private int numberOfFridayInPayPeriod(Date start, Date end) {
        Calendar startCal = Calendar.getInstance();
        startCal.setTime(start);
        Calendar endCal = Calendar.getInstance();
        endCal.setTime(end);

        int fridays = 0;
        int startDay = startCal.get(Calendar.DAY_OF_YEAR);
        int endDay = endCal.get(Calendar.DAY_OF_YEAR);
        while (startDay <= endDay) {
            if (ifFriday(startCal)) { // 是星期五加一
                fridays++;
            }
            startCal.set(Calendar.DAY_OF_YEAR, ++startDay);
        }
        return fridays;
    }

    private boolean ifFriday(Calendar calendar) {
        return calendar.get(Calendar.DAY_OF_WEEK) == 6;
    }

}
