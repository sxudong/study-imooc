package chapter16.refactoring;

import junit.framework.TestCase;

/**
 * 关于公历闰年是这样规定的:地球绕太阳公转一周叫做一回归年,一回归年长365日5时48分46秒。
 * 因此,公历规定有平年和闰年,平年一年有365日,比回归年短0.2422日,四年共短0.9688日,故每四年增加一日,
 * 这一年有366日,就是闰年。但四年增加一日比四个回归年又多0.0312日,400年后将多3.12日,故在400年中少
 * 设3个闰年,也就是在400年中只设97个闰年,这样公历年的平均长度与回归年就相近似了。由此规定:年份是整百
 * 数的必须是400的倍数才是闰年,例如1900年、2100年就不是闰年。
 *
 * 我们居住的地球总是绕着太阳旋转的。地球绕太阳转一圈需要365天5时48分46秒,也就是365.2422天。为了方便,
 * 一年定为365天,叫做平年;这样每过四年差不多就要多出一天来,把这一天加在2月里,这一年就有366天,叫做闰年。
 *
 * 通常,每四年里有三个平年一个闰年。公历年份是4的倍数的,一般都是闰年。
 */
public class DayDateTest extends TestCase {
    public void testGetPreviousDayOfWeek() throws Exception {
        assertEquals(d(24, Month.FEBRUARY.toInt(), 2006), d(1, Month.MARCH.toInt(), 2006).getPreviousDayOfWeek(Day.FRIDAY));
        // 2006年3月1日 星期三 的上个星期的星期三日期是：2006年2月22日
        assertEquals(d(22, Month.FEBRUARY.toInt(), 2006), d(1, Month.MARCH.toInt(), 2006).getPreviousDayOfWeek(Day.WEDNESDAY));
        // 2004年3月3日 星期三 的上个星期的星期六日期是：2004年2月22日
        assertEquals(d(29, Month.FEBRUARY.toInt(), 2004), d(3, Month.MARCH.toInt(), 2004).getPreviousDayOfWeek(Day.SUNDAY));
        // 2005年1月5日 星期三 的上个星期的星期三是：2004年12月29日
        assertEquals(d(29, Month.DECEMBER.toInt(), 2004), d(5, Month.JANUARY.toInt(), 2005).getPreviousDayOfWeek(Day.WEDNESDAY));
    }

    public void testGetFollowingDayOfWeek() throws Exception {
        assertEquals(d(1, Month.JANUARY.toInt(), 2005), d(25, Month.DECEMBER.toInt(), 2004).getFollowingDayOfWeek(Day.SATURDAY)); // 2004年12月25日 周六，下一周的周六应该是 2005年1月1日
        assertEquals(d(1, Month.JANUARY.toInt(), 2005), d(26, Month.DECEMBER.toInt(), 2004).getFollowingDayOfWeek(Day.SATURDAY));
        assertEquals(d(3, Month.MARCH.toInt(), 2004), d(28, Month.FEBRUARY.toInt(), 2004).getFollowingDayOfWeek(Day.WEDNESDAY));
    }

    public void testGetNearestDayOfWeek() throws Exception {
        assertEquals(d(16, Month.APRIL.toInt(), 2006), d(16, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.SUNDAY));
        assertEquals(d(16, Month.APRIL.toInt(), 2006), d(17, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.SUNDAY));
        assertEquals(d(16, Month.APRIL.toInt(), 2006), d(18, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.SUNDAY));
        assertEquals(d(16, Month.APRIL.toInt(), 2006), d(19, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.SUNDAY));
        assertEquals(d(23, Month.APRIL.toInt(), 2006), d(20, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.SUNDAY));
        assertEquals(d(23, Month.APRIL.toInt(), 2006), d(21, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.SUNDAY));
        assertEquals(d(23, Month.APRIL.toInt(), 2006), d(22, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.SUNDAY));

        assertEquals(d(17, Month.APRIL.toInt(), 2006), d(16, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.MONDAY));
        assertEquals(d(17, Month.APRIL.toInt(), 2006), d(17, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.MONDAY));
        assertEquals(d(17, Month.APRIL.toInt(), 2006), d(18, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.MONDAY));
        assertEquals(d(17, Month.APRIL.toInt(), 2006), d(19, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.MONDAY));
        assertEquals(d(17, Month.APRIL.toInt(), 2006), d(20, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.MONDAY));
        assertEquals(d(24, Month.APRIL.toInt(), 2006), d(21, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.MONDAY));
        assertEquals(d(24, Month.APRIL.toInt(), 2006), d(22, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.MONDAY));

        assertEquals(d(18, Month.APRIL.toInt(), 2006), d(18, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.TUESDAY));
        assertEquals(d(18, Month.APRIL.toInt(), 2006), d(19, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.TUESDAY));
        assertEquals(d(18, Month.APRIL.toInt(), 2006), d(20, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.TUESDAY));
        assertEquals(d(18, Month.APRIL.toInt(), 2006), d(21, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.TUESDAY));
        assertEquals(d(25, Month.APRIL.toInt(), 2006), d(22, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.TUESDAY));

        assertEquals(d(19, Month.APRIL.toInt(), 2006), d(16, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.WEDNESDAY));
        assertEquals(d(19, Month.APRIL.toInt(), 2006), d(17, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.WEDNESDAY));
        assertEquals(d(19, Month.APRIL.toInt(), 2006), d(18, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.WEDNESDAY));
        assertEquals(d(19, Month.APRIL.toInt(), 2006), d(19, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.WEDNESDAY));
        assertEquals(d(19, Month.APRIL.toInt(), 2006), d(20, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.WEDNESDAY));
        assertEquals(d(19, Month.APRIL.toInt(), 2006), d(21, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.WEDNESDAY));
        assertEquals(d(19, Month.APRIL.toInt(), 2006), d(22, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.WEDNESDAY));

        assertEquals(d(20, Month.APRIL.toInt(), 2006), d(19, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.THURSDAY));
        assertEquals(d(20, Month.APRIL.toInt(), 2006), d(20, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.THURSDAY));
        assertEquals(d(20, Month.APRIL.toInt(), 2006), d(21, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.THURSDAY));
        assertEquals(d(20, Month.APRIL.toInt(), 2006), d(22, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.THURSDAY));

        assertEquals(d(21, Month.APRIL.toInt(), 2006), d(20, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.FRIDAY));
        assertEquals(d(21, Month.APRIL.toInt(), 2006), d(21, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.FRIDAY));
        assertEquals(d(21, Month.APRIL.toInt(), 2006), d(22, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.FRIDAY));

        assertEquals(d(22, Month.APRIL.toInt(), 2006),  d(22, Month.APRIL.toInt(),2006).getNearestDayOfWeek(Day.SATURDAY));
    }

    public void testCompareTo() throws Exception { // DayDate.daysSince  《代码整洁之道》P266~267
        assertEquals(0, d(25, Month.DECEMBER.toInt(), 2004).compareTo(new SpreadsheetDate(25, Month.DECEMBER.toInt(), 2004)));
        assertEquals(6, d(26, Month.DECEMBER.toInt(), 2004).compareTo(new SpreadsheetDate(20, Month.DECEMBER.toInt(), 2004)));
        assertEquals(-8, d(20, Month.FEBRUARY.toInt(), 2004).compareTo(new SpreadsheetDate(28, Month.FEBRUARY.toInt(), 2004)));
    }

    private static chapter16.refactoring.SpreadsheetDate d(int day, int month, int year) {
        return new SpreadsheetDate(day, month, year);
    }
}