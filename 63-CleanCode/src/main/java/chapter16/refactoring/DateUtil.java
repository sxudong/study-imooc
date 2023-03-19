package chapter16.refactoring;

import java.text.DateFormatSymbols;

public class DateUtil { // 代码清单 B-13 (最终版本) P382
    private static DateFormatSymbols dateFormatSymbols = new DateFormatSymbols();

    public static String[] getMonthNames() {
        return dateFormatSymbols.getMonths();
    }
    // 是否是闰年？
    public static boolean isLeapYear(int year) { // SerialDate.isLeapYear() 《代码整洁之道》P263
        boolean fourth = year % 4 == 0;
        boolean hundredth = year % 100 == 0;
        boolean fourHundredth = year % 400 == 0;
        return fourth && (!hundredth || fourHundredth); // year % 4 == 0 && year % 25 != 0 || year % 16 == 0
    }

    public static int lastDayOfMonth(Month month, int year) { // SerialDate.lastDayOfMonth() 《代码整洁之道》P263
        if(month == Month.FEBRUARY && isLeapYear(year))
            return month.lastDay() + 1;
        else
            return month.lastDay();
    }
    // 闰年计数
    public static int leapYearCount(int year) { // SerialDate.leapYearCount() 《代码整洁之道》P263
        int leap4 = (year - 1896) / 4;
        int leap100 = (year - 1800) / 100;
        int leap400 = (year - 1600) / 400;
        return leap4 - leap100 + leap400;
    }
}
