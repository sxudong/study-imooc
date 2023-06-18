package com.payroll.payrollImpl;

import com.payroll.payrollDomain.PaymentSchedule;
import com.payroll.util.DateUtil;

import java.util.Calendar;
import java.util.Date;

public class WeeklySchedule extends PaymentSchedule {

    @Override
    public boolean isPayDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return calendar.get(Calendar.DAY_OF_WEEK) == 6; // 6 星期五、7 星期六，只有等于6才是星期五
    }

    @Override
    public Date getPayPeriodStartDate(Date payPeriodEndDate) {
        return DateUtil.add(payPeriodEndDate, Calendar.DAY_OF_YEAR, -4); // 星期五减4天是星期一
    }
}
