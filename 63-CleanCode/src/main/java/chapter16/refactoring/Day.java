package chapter16.refactoring;

import java.text.DateFormatSymbols;
import java.util.Calendar;
import java.util.Locale;

public enum Day { // 代码清单 B-9 (最终版本) P380
    SUNDAY(Calendar.SUNDAY), // 星期日
    MONDAY(Calendar.MONDAY), // 星期一
    TUESDAY(Calendar.TUESDAY), // 星期二
    WEDNESDAY(Calendar.WEDNESDAY), // 星期三
    THURSDAY(Calendar.THURSDAY), // 星期四
    FRIDAY(Calendar.FRIDAY), // 星期五
    SATURDAY(Calendar.SATURDAY); // 星期六

    private final int index;
    /**
     * DateFormatSymbols 是一个公共类，用于封装可本地化的 日期-时间 格式化数据，如月名、星期几的名称和时区数据。
     * DateFormat 和 SimpleDateFormat 都使用 DateFormatSymbols 来封装此信息。
     */
    private static DateFormatSymbols dateSymbols = new DateFormatSymbols(Locale.US); // 加上 Locale.US，不然输出是中文的星期一到星期日

    Day(int day) {
        index = day;
    }

    public static Day fromInt(int index) throws IllegalArgumentException {
        for (Day d : Day.values())
            if(d.index == index)
                return d;
        throw new IllegalArgumentException(String.format("Illegal day index: %d.", index));
    }

    public static Day parse(String s) throws IllegalArgumentException {
        String[] shortWeekdayNames = dateSymbols.getShortWeekdays(); // ["", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        String[] weekDayNames = dateSymbols.getWeekdays();         // ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        s = s.trim();
        for(Day day : Day.values()) {                             // 我不喜欢 for 循环（SerialDate 第259行 和 第263行）中的那些 if 语句[重复]，
            if(s.equalsIgnoreCase(shortWeekdayNames[day.index])   // 所以我用“||”操作符把它们连接为单个 if 语句。我还使用 Day 枚举整理 for 循环，做了一些装饰性的修改。 《代码整洁之道》P261
                    || s.equalsIgnoreCase(weekDayNames[day.index])) {
                return day;
            }
        }
        throw new IllegalArgumentException(String.format("%s is not a valid weekday string", s));
    }

    public String toString() {
        return dateSymbols.getWeekdays()[index];
    }

    public int toInt() {
        return index;
    }
}
