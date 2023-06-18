package com.payroll.util;

import java.util.Calendar;
import java.util.Date;

public class DateUtil {

    /**
     * 程序19.49 P216
     * 这个函数确保仅仅统计支付期内的时间卡。
     */
    public static boolean isInPayPeriod(Date theDate, Paycheck paychek) { // 改名为 isBetween P218
        Date startDate = paychek.getPayPeriodStartDate();
        Date endDate = paychek.getPayPeriodEndDate();
        // 日期是否大于计薪开始日期，日期是否小于计薪结束日期，两个都满足才可以计算工资
        return startDate.compareTo(theDate) <= 0 && theDate.compareTo(endDate) <= 0;
    }

    public static boolean isLastDayOfMonth(Date date) {
        Calendar c1 = Calendar.getInstance();
        c1.setTime(date);

        Calendar c2 = Calendar.getInstance();
        c2.setTime(add(date, Calendar.DAY_OF_YEAR, 1));

        int m1 = c1.get(Calendar.MONTH);
        int m2 = c2.get(Calendar.MONTH);
        return m1 != m2;
    }

    public static Date add(Date date, int field, int value) {
        if (date == null) {
            return null;
        }

        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        // 1 则代表的是对年份操作，2 是对月份操作，3 是对星期操作，5 是对日期操作，11 是对小时操作，12 是对分钟操作，13 是对秒操作，14是对毫秒操作
        // value = -1 表示日期为前一天,将当前日期加 value 天
        cal.add(field, value);
        return cal.getTime();
    }
}
