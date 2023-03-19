package chapter16.refactoring;

import java.text.DateFormatSymbols;
import java.util.Locale;

//  MonthConstants 改成枚举 Month
public enum Month { // 代码清单 B-8 P379
    JANUARY(1),
    FEBRUARY(2),
    MARCH(3),
    APRIL(4),
    MAY(5),
    JUNE(6),
    JULY(7),
    AUGUST(8),
    SEPTEMBER(9),
    OCTOBER(10),
    NOVEMBER(11),
    DECEMBER(12);
    private static DateFormatSymbols dateFormatSymbols = new DateFormatSymbols(Locale.US); // 加上 Locale.US，不然输出是中文的“一月”、“二月”...
    private static final int[] LAST_DAY_OF_MONTH =
            {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    private int index;

    Month(int index) {
        this.index = index;
    }

    public static Month fromInt(int monthIndex) {
        for (Month m : Month.values()) {
            if (m.index == monthIndex)
                return m;
        }
        throw new IllegalArgumentException("Invalid month index " + monthIndex);
    }

    public int lastDay() { // SerialDate.lastDayOfMonth() 《代码整洁之道》P263
        return LAST_DAY_OF_MONTH[index];
    }

    public int quarter() { // 重构自 SerialDate.monthCodeToQuarter() 《代码整洁之道》P262
        return 1 + (index - 1) / 3;
    }

    public String toString() { // SerialDate.monthCodeToString() 《代码整洁之道》P262
        return dateFormatSymbols.getMonths()[index - 1];
    }

    public String toShortString() { // SerialDate.monthCodeToString() 《代码整洁之道》P262
        return dateFormatSymbols.getShortMonths()[index - 1];
    }

    public static Month parse(String s) { // SerialDate.stringToMonthCode() 《代码整洁之道》P263
        s = s.trim();
        for (Month m : Month.values())
            if(m.matches(s))
                return m;

        try {
            return fromInt(Integer.parseInt(s));
        } catch (NumberFormatException e) {
        }
        throw new IllegalArgumentException("Invalid month " + s);
    }

    private boolean matches(String s) {
        return s.equalsIgnoreCase(toString()) || s.equalsIgnoreCase(toShortString());
    }

    public int toInt() {
        return index;
    }
}
