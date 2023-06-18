package com.payroll.payrollImpl;

import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.util.DateUtil;
import com.payroll.util.Paycheck;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 支付类别 : 按小时支付
 * 程序19.45 P214
 */
public class HourlyClassification extends PaymentClassification {

    private static final double WORK_HOUR_OF_DAY = 8.0;

    private static final double MORE_PAY_RATE = 1.5;

    /** 时薪 */
    private double hourlyRate;
    /** 时间卡 */
    private Map<Date, TimeCard> timeCards;

    public HourlyClassification(double hourlyRate) {
        this.hourlyRate = hourlyRate;
        this.timeCards = new HashMap<>();
    }

    //public void addTimeCard(TimeCard timeCard) {
    public void addTimeCard(Date date, double hours) {
        //TimeCard timeCard = new TimeCard(date, hours);
        TimeCard timeCard = PayrollFactoryImpl.getInstance().makeTimeCard(date, hours);
        this.timeCards.put(timeCard.getDate(), timeCard);
    }

    public TimeCard getTimeCard(Date date) {
        return timeCards.get(date);
    }


    @Override
    public double calculatePay(Paycheck paycheck) {
        double totalPay = 0;
        for(TimeCard tc : timeCards.values()){
            // 就算是多张时间卡，每张都要判断是否在计薪日内才可以计算工资。
            if(DateUtil.isInPayPeriod(tc.getDate(), paycheck)){ // 程序19.49 P216
                totalPay += calculatePayForTimeCard(tc); // 计算工时
            }
        }
        return totalPay;
    }

    // 超过8个小时工作时间后，加班费按1.5倍计算
    private double calculatePayForTimeCard(TimeCard timeCard) {
        double hours = timeCard.getHours();
        double overTime = Math.max(0.0, hours - WORK_HOUR_OF_DAY);
        double straightTime = hours - overTime; // 正式工作时间；规定工时
        return straightTime * hourlyRate + overTime * hourlyRate * MORE_PAY_RATE;
    }

    public double getHourlyRate() {
        return hourlyRate;
    }
}
