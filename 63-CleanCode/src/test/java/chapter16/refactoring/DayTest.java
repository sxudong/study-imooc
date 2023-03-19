package chapter16.refactoring;

import junit.framework.TestCase;

import java.util.Calendar;

public class DayTest extends TestCase {

    public void testStringToWeekdayCode() throws Exception {
        // stringToWeekdayCode() 移到 Day 中改名 parse()
        assertEquals(Calendar.MONDAY, Day.parse("Monday").toInt());
        assertEquals(Calendar.MONDAY, Day.parse("Mon").toInt());

        assertEquals(Calendar.TUESDAY, Day.parse("Tuesday").toInt());
        assertEquals(Calendar.TUESDAY, Day.parse("Tue").toInt());

        assertEquals(Calendar.WEDNESDAY, Day.parse("Wednesday").toInt());
        assertEquals(Calendar.WEDNESDAY, Day.parse("Wed").toInt());

        assertEquals(Calendar.THURSDAY, Day.parse("Thursday").toInt());
        assertEquals(Calendar.THURSDAY, Day.parse("Thu").toInt());

        assertEquals(Calendar.FRIDAY, Day.parse("Friday").toInt());
        assertEquals(Calendar.FRIDAY, Day.parse("Fri").toInt());

        assertEquals(Calendar.SATURDAY, Day.parse("Saturday").toInt());
        assertEquals(Calendar.SATURDAY, Day.parse("Sat").toInt());

        assertEquals(Calendar.SUNDAY, Day.parse("Sunday").toInt());
        assertEquals(Calendar.SUNDAY, Day.parse("Sun").toInt());
    }

    public void testWeekdayCodeToString() throws Exception {
        assertEquals("Sunday", Day.fromInt(Calendar.SUNDAY).toString());
        assertEquals("Monday", Day.fromInt(Calendar.MONDAY).toString());
        assertEquals("Tuesday", Day.fromInt(Calendar.TUESDAY).toString());
        assertEquals("Wednesday", Day.fromInt(Calendar.WEDNESDAY).toString());
        assertEquals("Thursday", Day.fromInt(Calendar.THURSDAY).toString());
        assertEquals("Friday", Day.fromInt(Calendar.FRIDAY).toString());
        assertEquals("Saturday", Day.fromInt(Calendar.SATURDAY).toString());
    }
}