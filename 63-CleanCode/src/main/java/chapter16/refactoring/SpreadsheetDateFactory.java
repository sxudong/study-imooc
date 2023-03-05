package chapter16.refactoring;

import java.util.*;

public class SpreadsheetDateFactory extends DayDateFactory { // 代码清单 B-15 (最终版本) P383

    @Override
    protected DayDate _makeDate(int ordinal) {
        return new SpreadsheetDate(ordinal);
    }

    @Override
    protected DayDate _makeDate(int day, Month month, int year) {
        return new SpreadsheetDate(day, month, year);
    }

    @Override
    protected DayDate _makeDate(int day, int month, int year) {
        return new SpreadsheetDate(day, month, year);
    }

    @Override
    protected DayDate _makeDate(Date date) {
        final GregorianCalendar calendar = new GregorianCalendar();
        calendar.setTime(date) ;
        return new SpreadsheetDate (
                calendar.get(Calendar.DATE),
                Month.fromInt(calendar.get(Calendar.MONTH) + 1),
                calendar.get(Calendar.YEAR));
    }

    @Override
    protected int _getMinimumYear() {
        return SpreadsheetDate.MINIMUM_YEAR_SUPPORTED;
    }

    @Override
    protected int _getMaximumYear() {
        return SpreadsheetDate.MAXIMUM_YEAR_SUPPORTED;
    }
}
