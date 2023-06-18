package com.payroll.payrollImpl;

import java.util.Date;

/**
 * 19.3 钟点工 时间卡 P190
 */
public class TimeCard {
    private Date date;
    /** 工作时长 */
    private double hours;

    public TimeCard(Date date, double hours) {
        this.date = date;
        this.hours = hours;
    }

    public Date getDate() {
        return date;
    }

    public double getHours() {
        return hours;
    }
}
