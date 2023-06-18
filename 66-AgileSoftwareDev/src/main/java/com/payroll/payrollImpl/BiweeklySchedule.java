package com.payroll.payrollImpl;

import com.payroll.payrollDomain.PaymentSchedule;
import com.payroll.util.DateUtil;

import java.util.Calendar;
import java.util.Date;

public class BiweeklySchedule extends PaymentSchedule {

    @Override
    public boolean isPayDate(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return calendar.get(Calendar.DAY_OF_WEEK) == 6;
    }

    @Override
    public Date getPayPeriodStartDate(Date payPeriodEndDate) {
        return DateUtil.add(payPeriodEndDate, Calendar.DAY_OF_YEAR, -(4 + 7));
    }
}
