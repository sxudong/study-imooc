package chapter16.refactoring;

import java.util.GregorianCalendar;
import java.util.Calendar;
import java.util.Locale;
import java.text.SimpleDateFormat;

/**
 * Java 中 SimpleDateFormat 的一点技巧，将星期几的中文变成英文输出
 */
public class abc {
    public static void main(String[] args) {
        GregorianCalendar gc = new GregorianCalendar();
        int today = gc.get(Calendar.DAY_OF_MONTH);
        int month = gc.get(Calendar.MONTH);
        gc.set(Calendar.DAY_OF_MONTH, 1);

        int weekday = gc.get(Calendar.DAY_OF_WEEK);

        int weekOfFirstDay = gc.getFirstDayOfWeek();

        int indent = 0;
        while (weekday != weekOfFirstDay) {
            indent++;
            gc.add(Calendar.DAY_OF_MONTH, -1);
            ;
            weekday = gc.get(Calendar.DAY_OF_WEEK);
        }

        SimpleDateFormat sdf = new SimpleDateFormat("F", Locale.US);
        String[] weekdayNames = sdf.getDateFormatSymbols().getShortWeekdays();

        do {
            System.out.printf("%4s", weekdayNames[weekday]);
            gc.add(Calendar.DAY_OF_MONTH, 1);
            weekday = gc.get(Calendar.DAY_OF_WEEK);
        } while (weekday != weekOfFirstDay);

        System.out.println();
    }
}