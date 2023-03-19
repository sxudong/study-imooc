/* ========================================================================
 * JCommon : a free general purpose class library for the Java(tm) platform
 * ========================================================================
 *
 * (C) Copyright 2000-2006, by Object Refinery Limited and Contributors.
 *
 * Project Info:  http://www.jfree.org/jcommon/index.html
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
 * USA.
 *
 * [Java is a trademark or registered trademark of Sun Microsystems, Inc.
 * in the United States and other countries.]
 *
 * ---------------
 * SerialDate.java
 * ---------------
 * (C) Copyright 2001-2006, by Object Refinery Limited.
 *
 * Original Author:  David Gilbert (for Object Refinery Limited);
 * Contributor(s):   -;
 *
 * $Id: SerialDate.java,v 1.9 2011/10/17 20:08:22 mungady Exp $
 */
package chapter16.refactoring;

import java.io.Serializable;
import java.util.*;
/**
 * 代码清单 B-1 https://github.com/jfree/jcommon
 * An abstract class that represents immutable dates with a precision of
 * one day.The implementation will map each date to an integer that
 * represents an ordinal number of days from some fixed origin.
 * <p>
 * Why not just use java.util.Date?  We will, when it makes sense.  At times,
 * java.util.Date can be *too* precise - it represents an instant in time,
 * accurate to 1/1000th of a second (with the date itself depending on the
 * time-zone).  Sometimes we just want to represent a particular day (e.g. 21
 * January 2015) without concerning ourselves about the time of day, or the
 * time-zone, or anything else.  That's what we've defined SerialDate for.
 * <p>
 * Use DayDateFactory.makeDate to create an instance.
 *
 * @author David Gilbert
 * @author Robert C.Martin did a lot of refactoring.
 */
// 代码清单 B-7 (最终版本) P376
public abstract class DayDate implements Comparable, Serializable {

    public abstract int getOrdinalDay();
    public abstract int getYear();
    public abstract Month getMonth();
    public abstract int getDayOfMonth();
    protected abstract Day getDayOfWeekForOrdinalZero(); // 创建 getDayOfWeekForOrdinalZero 抽象方法，在 SpreadsheetDate 中实现它。 《代码整洁之道》P266

    public DayDate plusDays(int days) { // SerialDate.addDays()
        return DayDateFactory.makeDate(getOrdinalDay() + days); // 名称改为 getOrdinalDay()  《代码整洁之道》P266
    }

    public DayDate plusMonths(int months) { // SerialDate.addMonths()
        int thisMonthAsOrdinal = getMonth().toInt() - Month.JANUARY.toInt();
        int thisMonthAndYearAsordinal = 12 * getYear() + thisMonthAsOrdinal;
        int resultMonthAndYearAs0rdinal = thisMonthAndYearAsordinal + months;
        int resultYear = resultMonthAndYearAs0rdinal / 12;
        int resultMonthAsOrdinal = resultMonthAndYearAs0rdinal % 12 + Month.JANUARY.toInt();
        Month resultMonth = Month.fromInt(resultMonthAsOrdinal);
        int resultDay = correctLastDayOfMonth(getDayOfMonth(), resultMonth, resultYear);
        return DayDateFactory.makeDate(resultDay, resultMonth, resultYear);
    }

    public DayDate plusYears(int years) { // SerialDate.addYears()
        int resultYear = getYear() + years;
        int resultDay = correctLastDayOfMonth(getDayOfMonth(), getMonth(), resultYear);
        return DayDateFactory.makeDate(resultDay, getMonth(), resultYear);
    }

    private int correctLastDayOfMonth(int day, Month month, int year) {
        int lastDayOfMonth = DateUtil.lastDayOfMonth(month, year);
        if (day > lastDayOfMonth)
            day = lastDayOfMonth;
        return day;
    }

    public DayDate getPreviousDayOfWeek(Day targetDayOfWeek) { // SerialDate.getPreviousDayOfWeek() 《代码整洁之道》P264~P265
        int offsetToTarget = targetDayOfWeek.toInt() - getDayOfWeek().toInt(); // 0
        if (offsetToTarget >= 0)
            offsetToTarget -= 7;
        return plusDays(offsetToTarget);
    }

    public DayDate getFollowingDayOfWeek(Day targetDayOfWeek) { // SerialDate.getFollowingDayOfWeek() 《代码整洁之道》P265
        int offsetToTarget = targetDayOfWeek.toInt() - getDayOfWeek().toInt();
        if(offsetToTarget <= 0)
            offsetToTarget += 7;
        return plusDays(offsetToTarget);
    }

    public DayDate getNearestDayOfWeek(Day targetDayOfWeek) { // SerialDate.getNearestDayOfWeek() 《代码整洁之道》P265
        int offsetToThisWeeksTarget =  targetDayOfWeek.toInt() - getDayOfWeek().toInt();
        int offsetToFutureTarget = (offsetToThisWeeksTarget + 7) % 7;
        int offsetToPreviousTarget = offsetToFutureTarget - 7;

        if (offsetToFutureTarget > 3)
            return plusDays(offsetToPreviousTarget);
        else
            return plusDays(offsetToFutureTarget);
    }

    public DayDate getEndOfMonth() { // SerialDate.getEndOfMonth() 《代码整洁之道》P265
        Month month = getMonth();
        int year = getYear();
        int lastDay = DateUtil.lastDayOfMonth(month, year);
        return DayDateFactory.makeDate(lastDay, month, year);
    }

    public Date toDate() { // 在 SerialDate 中定义的是抽象方法，取消抽象方法上推到父类 DayDate 中。 《代码整洁之道》P266
        final Calendar calendar = Calendar.getInstance();
        int ordinalMonth = getMonth().toInt() - Month.JANUARY.toInt();
        calendar.set(getYear(), ordinalMonth, getDayOfMonth(), 0, 0, 0);
        return calendar.getTime();
    }

    public String toString() {
        return String.format("%02d-%s-%d", getDayOfMonth(), getMonth(), getYear());
    }
    // SpreadsheetDate.getDayOfWeek() { return (this.serial + 6) % 7 + 1;} // 第0天的星期日数，星期日 0，星期一 1，星期二 2，星期三 3，星期四 4，星期五 5，星期六 6，到 7 变 0。
    public Day getDayOfWeek() { // SerialDate.getDayOfWeek() 抽象方法上移在 DayDate 父类实现。 《代码整洁之道》P266
        Day startingDay = getDayOfWeekForOrdinalZero(); // 算法本身也应该有一小部分依赖实现
        int startingOffset = startingDay.toInt() - Day.SUNDAY.toInt(); // 7-1
        int ordinalOfDayOfWeek = (getOrdinalDay() + startingOffset) % 7; // 相当于 (this.serial + 6) % 7
        return Day.fromInt(ordinalOfDayOfWeek + Day.SUNDAY.toInt()); // + 1
    }

    public int daysSince(DayDate date) {
        return getOrdinalDay() - date.getOrdinalDay();
    }

    public boolean isOn(DayDate other) {
        return getOrdinalDay() == other.getOrdinalDay();
    }

    public boolean isBefore(DayDate other) {
        return getOrdinalDay() < other.getOrdinalDay();
    }

    public boolean isOnOrBefore(DayDate other) {
        return getOrdinalDay() <= other.getOrdinalDay();
    }

    public boolean isAfter(DayDate other) {
        return getOrdinalDay() > other.getOrdinalDay();
    }

    public boolean isOnOrAfter(DayDate other) {
        return getOrdinalDay() >= other.getOrdinalDay();
    }

    public boolean isInRange(DayDate d1, DayDate d2) {
        return isInRange(d1, d2, DateInterval.CLOSED);
    }

    public boolean isInRange(DayDate d1, DayDate d2, DateInterval interval) {
        int left = Math.min(d1.getOrdinalDay(), d2.getOrdinalDay());
        int right = Math.max(d1.getOrdinalDay(), d2.getOrdinalDay());
        return interval.isIn(getOrdinalDay(), left, right);
    }
}