/* ========================================================================
 * JCommon : a free general purpose class library for the Java(tm) platform
 * ========================================================================
 * 最终版本 DayDate 替代了 SerialDate
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
 *
 * Changes (from 11-Oct-2001)
 * --------------------------
 * 11-Oct-2001 : Re-organised the class and moved it to new package
 *               com.jrefinery.date (DG);
 * 05-Nov-2001 : Added a getDescription() method, and eliminated NotableDate
 *               class (DG);
 * 12-Nov-2001 : IBD requires setDescription() method, now that NotableDate
 *               class is gone (DG);  Changed getPreviousDayOfWeek(),
 *               getFollowingDayOfWeek() and getNearestDayOfWeek() to correct
 *               bugs (DG);
 * 05-Dec-2001 : Fixed bug in SpreadsheetDate class (DG);
 * 29-May-2002 : Moved the month constants into a separate interface
 *               (MonthConstants) (DG);
 * 27-Aug-2002 : Fixed bug in addMonths() method, thanks to N???levka Petr (DG);
 * 03-Oct-2002 : Fixed errors reported by Checkstyle (DG);
 * 13-Mar-2003 : Implemented Serializable (DG);
 * 29-May-2003 : Fixed bug in addMonths method (DG);
 * 04-Sep-2003 : Implemented Comparable.  Updated the isInRange javadocs (DG);
 * 05-Jan-2005 : Fixed bug in addYears() method (1096282) (DG);
 */

package org.jfree.date;

import java.io.Serializable;
import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;

/** 代码清单 B-1 https://github.com/jfree/jcommon
 *  An abstract class that defines our requirements for manipulating dates,
 *  without tying down a particular implementation.
 *  <P>
 *  Requirement 1 : match at least what Excel does for dates;
 *  Requirement 2 : the date represented by the class is immutable;
 *  <P>
 *  Why not just use java.util.Date?  We will, when it makes sense.  At times,
 *  java.util.Date can be *too* precise - it represents an instant in time,
 *  accurate to 1/1000th of a second (with the date itself depending on the
 *  time-zone).  Sometimes we just want to represent a particular day (e.g. 21
 *  January 2015) without concerning ourselves about the time of day, or the
 *  time-zone, or anything else.  That's what we've defined SerialDate for.
 *  <P>
 *  You can call getInstance() to get a concrete subclass of SerialDate,
 *  without worrying about the exact implementation.
 *
 * @author David Gilbert
 */
public abstract class SerialDate implements Comparable,
                                            Serializable,
                                            MonthConstants { // 代码清单 B-1 P326 最终版本 DayDate 替代了 SerialDate。把 MonthConstants 改成枚举 Month

    /** For serialization. */
    private static final long serialVersionUID = -293716040467423637L; // 暂时的删除版本号

    /** Date format symbols. */ // 多余的注释，应当删除
    public static final DateFormatSymbols
        DATE_FORMAT_SYMBOLS = new SimpleDateFormat("F", Locale.US).getDateFormatSymbols(); // 加上 Locale.US，不然输出是中文的星期一到星期日

    /** The serial number for 1 January 1900. */
    public static final int SERIAL_LOWER_BOUND = 2; // 应该改成描述性的名称 EARLIEST_DATE_ORDINAL = 2;     // 1/1/1900  重构移到 SpreadsheetDate 类中

    /** The serial number for 31 December 9999. */
    public static final int SERIAL_UPPER_BOUND = 2958465; // 应该改成描述性的名称LATEST_DATE_ORDINAL = 2958465; // 12/31/9999  重构移到 SpreadsheetDate 类中

    /** The lowest year value supported by this date format. */
    public static final int MINIMUM_YEAR_SUPPORTED = 1900;  // 重构移到 SpreadsheetDate 类中

    /** The highest year value supported by this date format. */
    public static final int MAXIMUM_YEAR_SUPPORTED = 9999;  // 重构移到 SpreadsheetDate 类中

    /** Useful constant for Monday. Equivalent to java.util.Calendar.MONDAY. */ // 这些注释多余，光看名称就足够了，所以要删除这些注释。
    public static final int MONDAY = Calendar.MONDAY; // 移到 Day 枚举类中

    /**
     * Useful constant for Tuesday. Equivalent to java.util.Calendar.TUESDAY.
     */
    public static final int TUESDAY = Calendar.TUESDAY;

    /**
     * Useful constant for Wednesday. Equivalent to
     * java.util.Calendar.WEDNESDAY.
     */
    public static final int WEDNESDAY = Calendar.WEDNESDAY;

    /**
     * Useful constant for Thrusday. Equivalent to java.util.Calendar.THURSDAY.
     */
    public static final int THURSDAY = Calendar.THURSDAY;

    /** Useful constant for Friday. Equivalent to java.util.Calendar.FRIDAY. */
    public static final int FRIDAY = Calendar.FRIDAY;

    /**
     * Useful constant for Saturday. Equivalent to java.util.Calendar.SATURDAY.
     */
    public static final int SATURDAY = Calendar.SATURDAY;

    /** Useful constant for Sunday. Equivalent to java.util.Calendar.SUNDAY. */
    public static final int SUNDAY = Calendar.SUNDAY;

    /** The number of days in each month in non leap years. */
    static final int[] LAST_DAY_OF_MONTH =
        {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};  // 这个数组没理由不是私有的，因为有一个静态函数 lastDayOfMonth 提供同样的数据。

    /** The number of days in a (non-leap) year up to the end of each month. */
    static final int[] AGGREGATE_DAYS_TO_END_OF_MONTH =
        {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365}; // 这个数据根据就没有用到，是一个死代码，直接删除

    /** The number of days in a year up to the end of the preceding month. */
    static final int[] AGGREGATE_DAYS_TO_END_OF_PRECEDING_MONTH =
        {0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};

    /** The number of days in a leap year up to the end of each month. */
    static final int[] LEAP_YEAR_AGGREGATE_DAYS_TO_END_OF_MONTH =
        {0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366};  // 这个数据根据就没有用到，是一个死代码，直接删除

    /**
     * The number of days in a leap year up to the end of the preceding month.
     */
    static final int[]
        LEAP_YEAR_AGGREGATE_DAYS_TO_END_OF_PRECEDING_MONTH =
            {0, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}; // 下移到 SpreadsheetDate 中

    /** A useful constant for referring to the first week in a month. */
    public static final int FIRST_WEEK_IN_MONTH = 1;  // 转换为名为 WeekInMonth 的枚举类 《代码整洁之道》P260

    /** A useful constant for referring to the second week in a month. */
    public static final int SECOND_WEEK_IN_MONTH = 2; // 转换为名为 WeekInMonth 的枚举类

    /** A useful constant for referring to the third week in a month. */
    public static final int THIRD_WEEK_IN_MONTH = 3;  // 转换为名为 WeekInMonth 的枚举类

    /** A useful constant for referring to the fourth week in a month. */
    public static final int FOURTH_WEEK_IN_MONTH = 4; // 转换为名为 WeekInMonth 的枚举类

    /** A useful constant for referring to the last week in a month. */
    public static final int LAST_WEEK_IN_MONTH = 0;  // 转换为名为 WeekInMonth 的枚举类

    /** Useful range constant. */
    public static final int INCLUDE_NONE = 0;       // 转换为枚举 DateInterval 《代码整洁之道》P260

    /** Useful range constant. */
    public static final int INCLUDE_FIRST = 1;      // 转换为枚举 DateInterval

    /** Useful range constant. */
    public static final int INCLUDE_SECOND = 2;     // 转换为枚举 DateInterval

    /** Useful range constant. */
    public static final int INCLUDE_BOTH = 3;       // 转换为枚举 DateInterval

    /**
     * Useful constant for specifying a day of the week relative to a fixed
     * date.
     */
    public static final int PRECEDING = -1;         // 转换为 WeekdayRange 枚举类 《代码整洁之道》P260

    /**
     * Useful constant for specifying a day of the week relative to a fixed
     * date.
     */
    public static final int NEAREST = 0;            // 转换为 WeekdayRange 枚举类

    /**
     * Useful constant for specifying a day of the week relative to a fixed
     * date.
     */
    public static final int FOLLOWING = 1;          // 转换为 WeekdayRange 枚举类

    /** A description for the date. */
    private String description; // 没有任何地方用到，把它及取值器和赋值器都删掉了。

    /**
     * Default constructor.
     */
    protected SerialDate() { // 删掉默认的构造器，编译器会为我们自动生成
    }

    /**
     * Returns <code>true</code> if the supplied integer code represents a
     * valid day-of-the-week, and <code>false</code> otherwise.
     *
     * @param code  the code being checked for validity.
     *
     * @return <code>true</code> if the supplied integer code represents a
     *         valid day-of-the-week, and <code>false</code> otherwise.
     */
    public static boolean isValidWeekdayCode(final int code) { // 第216行~238行，在创建 Day 枚举时已经把它删掉了。 《代码整洁之道》P260

        switch(code) {
            case SUNDAY:
            case MONDAY:
            case TUESDAY:
            case WEDNESDAY:
            case THURSDAY:
            case FRIDAY:
            case SATURDAY:
                return true;
            default:
                return false;
        }

    }

    /**
     * Converts the supplied string to a day of the week.    // 第242~270 没有方法签名增添价值的 Javadoc 都是废话，唯一的价值是对返回值 -1 的描述。
     *                                                       // 然而我们改用了 Day 枚举，所以这条注释完全错误了。该方法现在 Day.parse() 中抛出了一个
     * @param s  a string representing the day of the week.  // IllegalArgumentException 异常，所以我删除了 Javadoc。
     *
     * @return <code>-1</code> if the string is not convertable, the day of
     *         the week otherwise.
     */
    public static int stringToWeekdayCode(String s) { // 我认为，这个方法并不真属于 DayDate 类，它其实是 Day 的一个解析函数 parse()。所以，我将它移到了 Day 枚举中。 《代码整洁之道》P261

        final String[] shortWeekdayNames              // 删除 变量声明中的 final 关键字
            = DATE_FORMAT_SYMBOLS.getShortWeekdays(); // 英文输出：["", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        final String[] weekDayNames = DATE_FORMAT_SYMBOLS.getWeekdays(); // ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        int result = -1;
        s = s.trim();
        for (int i = 0; i < weekDayNames.length; i++) { // 我不喜欢 for 循环（第259行 和 第263行）中的那些 if 语句[重复]，所以我用“||”操作符把它们连接为单个 if 语句。我还使用 Day 枚举整理 for 循环，做了一些装饰性的修改。 《代码整洁之道》P261
            if (s.equals(shortWeekdayNames[i])) { // 改为 equalsIgnoreCase 忽略大小写
                result = i;
                break;
            }
            if (s.equals(weekDayNames[i])) { // 改为 equalsIgnoreCase 忽略大小写
                result = i;
                break;
            }
        }
        return result;

    }

    /**
     * Returns a string representing the supplied day-of-the-week.
     * <P>
     * Need to find a better approach.
     *
     * @param weekday  the day of the week.
     *
     * @return a string representing the supplied day-of-the-week.
     */
    public static String weekdayCodeToString(final int weekday) { // 我还删除了参数和变量声明中的全部 final 关键字，我敢说，它们毫无价值，只会混淆视听。

        final String[] weekdays = DATE_FORMAT_SYMBOLS.getWeekdays();
        return weekdays[weekday];

    }

    /**
     * Returns an array of month names.
     *
     * @return an array of month names.
     */
    public static String[] getMonths() {    // 有两个 getMonths() 函数（第288~316行）。第一个函数调用第二个函数。
                                            // 第二个函数只被第一个函数调用。所以，我把这两个函数合二为一，而且极大的
        return getMonths(false);   // 简化之[G9死代码][G12混淆视听][F4死函数]。最后，我把名称修改得更具描
                                            // 述力[N1采用描述性名称]。getMonthNames()
    }

    /**
     * Returns an array of month names.
     *
     * @param shortened  a flag indicating that shortened month names should
     *                   be returned.
     *
     * @return an array of month names.
     */
    public static String[] getMonths(final boolean shortened) { // 删除参数中的 final 关键字

        if (shortened) {
            return DATE_FORMAT_SYMBOLS.getShortMonths();
        }
        else {
            return DATE_FORMAT_SYMBOLS.getMonths();
        }

    }

    /**
     * Returns true if the supplied integer code represents a valid month.
     *
     * @param code  the code being checked for validity.
     *
     * @return <code>true</code> if the supplied integer code represents a
     *         valid month.
     */
    public static boolean isValidMonthCode(final int code) { // 删除参数中的 final 关键字

        switch(code) {        // 由于有了 Month 枚举，函数 isValidMonthCode() (第326~346行)就变得没什么用，
            case JANUARY:     // 因此我把它删除[G9死代码]。 《代码整洁之道》P262
            case FEBRUARY:
            case MARCH:
            case APRIL:
            case MAY:
            case JUNE:
            case JULY:
            case AUGUST:
            case SEPTEMBER:
            case OCTOBER:
            case NOVEMBER:
            case DECEMBER:
                return true;
            default:
                return false;
        }

    }

    /**
     * Returns the quarter for the specified month.
     *
     * @param code  the month code (1-12).
     *
     * @return the quarter that the month belongs to.
     * @throws java.lang.IllegalArgumentException
     */
    public static int monthCodeToQuarter(final int code) { // 删除参数中的 final 关键字

        switch(code) {            // 函数 monthCodeToQuarter()（第356~375行）有特性依恋的味道，
            case JANUARY:         // 可以是 Month 枚举中的一个名为 quarter 的方法，我就这么办了。 《代码整洁之道》P262
            case FEBRUARY:
            case MARCH: return 1;
            case APRIL:
            case MAY:
            case JUNE: return 2;
            case JULY:
            case AUGUST:
            case SEPTEMBER: return 3;
            case OCTOBER:
            case NOVEMBER:
            case DECEMBER: return 4;
            default: throw new IllegalArgumentException(
                "SerialDate.monthCodeToQuarter: invalid month code.");
        }

    }

    /**
     * Returns a string representing the supplied month.
     * <P>
     * The string returned is the long form of the month name taken from the
     * default locale.
     *
     * @param month  the month.
     *
     * @return a string representing the supplied month.
     */
    public static String monthCodeToString(final int month) { // 删除参数中的 final 关键字
                                                           // 第377~426行，我们再次看到其中一个方法使用标识调用兄弟方法的模式。
        return monthCodeToString(month, false);   // 将标识作为参数传递给函数的做法通常不太好，尤其是当该标识只是有关
                                                            // 其输出格式时[G15选择算子参数]。我重命名、简化、重新构架了这些函数，
    }                                                       // 并把它们移到 Month 枚举中[N1采用描述性名称][N3尽可能使用标准命名法][G14特性依赖]。《代码整洁之道》P262

    /**
     * Returns a string representing the supplied month.
     * <P>
     * The string returned is the long or short form of the month name taken
     * from the default locale.
     *
     * @param month  the month.
     * @param shortened  if <code>true</code> return the abbreviation of the
     *                   month.
     *
     * @return a string representing the supplied month.
     * @throws java.lang.IllegalArgumentException
     */
    public static String monthCodeToString(final int month,
                                           final boolean shortened) { // 删除参数中的 final 关键字

        // check arguments...
        if (!isValidMonthCode(month)) {
            throw new IllegalArgumentException(
                "SerialDate.monthCodeToString: month outside valid range.");
        }

        final String[] months;

        if (shortened) {
            months = DATE_FORMAT_SYMBOLS.getShortMonths();
        }
        else {
            months = DATE_FORMAT_SYMBOLS.getMonths();
        }

        return months[month - 1];

    }

    /**
     * Converts a string to a month code.
     * <P>
     * This method will return one of the constants JANUARY, FEBRUARY, ...,
     * DECEMBER that corresponds to the string.  If the string is not
     * recognised, this method returns -1.
     *
     * @param s  the string to parse.
     *
     * @return <code>-1</code> if the string is not parseable, the month of the
     *         year otherwise.
     */
    public static int stringToMonthCode(String s) { // 第428~472行，我重新为它命名，转移到 Month 枚举类中，
                                                    // 并且简化之[N1采用描述性名称][N3尽可能使用标准命名法][C3冗余注释][G14特性依赖][G12混淆视听] 《代码整洁之道》P263
        final String[] shortMonthNames = DATE_FORMAT_SYMBOLS.getShortMonths();
        final String[] monthNames = DATE_FORMAT_SYMBOLS.getMonths();

        int result = -1;
        s = s.trim();

        // first try parsing the string as an integer (1-12)...
        try {
            result = Integer.parseInt(s);
        }
        catch (NumberFormatException e) {
            // suppress
        }

        // now search through the month names...
        if ((result < 1) || (result > 12)) {
            for (int i = 0; i < monthNames.length; i++) {
                if (s.equals(shortMonthNames[i])) { // 使用 equalsIgnoreCase 忽略大小写
                    result = i + 1;
                    break;
                }
                if (s.equals(monthNames[i])) { // 使用 equalsIgnoreCase 忽略大小写
                    result = i + 1;
                    break;
                }
            }
        }

        return result;

    }

    /**
     * Returns true if the supplied integer code represents a valid
     * week-in-the-month, and false otherwise.
     *
     * @param code  the code being checked for validity.
     * @return <code>true</code> if the supplied integer code represents a
     *         valid week-in-the-month.
     */
    public static boolean isValidWeekInMonthCode(final int code) {

        switch(code) {
            case FIRST_WEEK_IN_MONTH:
            case SECOND_WEEK_IN_MONTH:
            case THIRD_WEEK_IN_MONTH:
            case FOURTH_WEEK_IN_MONTH:
            case LAST_WEEK_IN_MONTH: return true;
            default: return false;
        }

    }

    /** 每 4 年一个闰年，但每 100 年少一个闰年，每 400 年又增加。
     * Determines whether or not the specified year is a leap year. 是不是闰年？
     *
     * @param yyyy  the year (in the range 1900 to 9999).
     *
     * @return <code>true</code> if the specified year is a leap year.
     */
    public static boolean isLeapYear(final int yyyy) { // 第495~517行，可以写得更具表达办一些[G16晦涩的意图] 移到 DateUtil 类中。《代码整洁之道》P263

        if ((yyyy % 4) != 0) { // boolean fourth = yyyy % 4 == 0;                // 四
            return false;      // 年份不是4的整数倍，会在第一个判断就返回
        }
        else if ((yyyy % 400) == 0) { // boolean fourHundredth = yyyy % 400 == 0; // 四百
            return true;              // 为了减少额外闰年判断 把时间往前推到1600年 即闰年最大的一次公倍数开始计算判断。比如1600年、2000年是闰年,但1700,1800,1900年不是
        }
        else if ((yyyy % 100) == 0) { // boolean hundredth = yyyy % 100 == 0;     // 一百
            return false;
        }
        else {
            return true; // return fourth && (!hundredth || fourHundredth);
        }
        // 这是闰年的条件吗：year % 4 == 0 && year % 100 != 0 || year % 400 == 0 判断它是否为闰年,判断闰年的条件是：年份能被4整除但不能被100整除,或者能被400整除.
    }

    /**
     * Returns the number of leap years from 1900 to the specified year
     * INCLUSIVE.
     * <P>
     * Note that 1900 is not a leap year.
     *
     * @param yyyy  the year (in the range 1900 to 9999).
     *
     * @return the number of leap years from 1900 to the specified year.
     */
    public static int leapYearCount(final int yyyy) { // 第519~536行 并不真属于 DayDate。除了 SpreadsheetDate 中的两个方法
                                                      // 没有其它调用者，所以我将它往下放。移到 DateUtil 类中。《代码整洁之道》P263
        final int leap4 = (yyyy - 1896) / 4;
        final int leap100 = (yyyy - 1800) / 100;
        final int leap400 = (yyyy - 1600) / 400;
        return leap4 - leap100 + leap400;

    }

    /**
     * Returns the number of the last day of the month, taking into account
     * leap years.
     *
     * @param month  the month.
     * @param yyyy  the year (in the range 1900 to 9999).
     *
     * @return the number of the last day of the month.
     */
    public static int lastDayOfMonth(final int month, final int yyyy) { // 第538~560行 使用了 LAST_DAY_OF_MONTH 数组，
                                                                        // 该数组应该隶属于 Month 枚举[G17位置错误的权责]
        final int result = LAST_DAY_OF_MONTH[month];                    // 所以我把它移到那儿去了。我还简化了这个函数，使其
        if (month != FEBRUARY) {                                        // 更具表达力[G16晦涩的意图]。 该方法移到 DateUtil 类中。
            return result;                                              // 《代码整洁之道》P263
        }
        else if (isLeapYear(yyyy)) {
            return result + 1;
        }
        else {
            return result;
        }

    }

    /**
     * Creates a new date by adding the specified number of days to the base
     * date.
     *
     * @param days  the number of days to add (can be negative).
     * @param base  the base date.
     *
     * @return a new date.
     */
    public static SerialDate addDays(final int days, final SerialDate base) { // => DayDate.plusDays() 消除歧义[N4无歧义的命名]把名称改为 plusDays 《代码整洁之道》P264
                                                             // 第562~576行 首先，由于该函数对 DayDate（也就是SerialDate）的变量
        final int serialDayNumber = base.toSerial() + days;  // 进行了操作，它就不该是静态的[G18不恰当的静态方法]，因此，我把它修改为
        return SerialDate.createInstance(serialDayNumber);   // 实体方法。其次，它调用了函数 toSerial()，这个函数应该重新命名为 toOrdinal()
        // return DayDateFactory.make(toOrdinal() + days);   // [N1采用描述性名称]。最后，该方法可以简化。 《代码整洁之道》P263
    }                                                        // toOrdinal() 名称改为 getOrdinalDay()  《代码整洁之道》P26

    /**
     * Creates a new date by adding the specified number of months to the base
     * date.
     * <P>
     * If the base date is close to the end of the month, the day on the result
     * may be adjusted slightly:  31 May + 1 month = 30 June.
     *
     * @param months  the number of months to add (can be negative).
     * @param base  the base date.
     *
     * @return a new date.
     */
    public static SerialDate addMonths(final int months,        // => DayDate.plusMonths() 消除歧义[N4无歧义的命名]把名称改为 plusMonths 《代码整洁之道》P264
                                       final SerialDate base) {
                                                                            // 第578~602行 也一样。它应该是一个实体方法[G18不恰当的静态方法]，
        final int yy = (12 * base.getYYYY() + base.getMonth() + months - 1) // 算法过于复杂，所以我利用解释临时变量模式（explaining temporary variables）来使其更为透明。
                       / 12;                                                // 我还将方法 getYYYY() 重命名为 getYear() [N1采用描述性名称]。 《代码整洁之道》P264
        final int mm = (12 * base.getYYYY() + base.getMonth() + months - 1)
                       % 12 + 1;
        final int dd = Math.min(
            base.getDayOfMonth(), SerialDate.lastDayOfMonth(mm, yy)
        );
        return SerialDate.createInstance(dd, mm, yy);

    }

    /**
     * Creates a new date by adding the specified number of years to the base
     * date.
     *
     * @param years  the number of years to add (can be negative).
     * @param base  the base date.
     *
     * @return A new date.
     */
    public static SerialDate addYears(final int years, final SerialDate base) { // => DayDate.plusYears()
                                                 // 第578~602行 也照样办理。 《代码整洁之道》P264
        final int baseY = base.getYYYY();
        final int baseM = base.getMonth();
        final int baseD = base.getDayOfMonth();

        final int targetY = baseY + years;
        final int targetD = Math.min(
            baseD, SerialDate.lastDayOfMonth(baseM, targetY)
        );

        return SerialDate.createInstance(targetD, baseM, targetY);

    }

    /**
     * Returns the latest date that falls on the specified day-of-the-week and
     * is BEFORE the base date.
     *
     * @param targetWeekday  a code for the target day-of-the-week.
     * @param base  the base date.
     *
     * @return the latest date that falls on the specified day-of-the-week and
     *         is BEFORE the base date.
     */
    public static SerialDate getPreviousDayOfWeek(final int targetWeekday,
                                                  final SerialDate base) {  // => DayDate.getPreviousDayOfWeek()

        // check arguments...
        if (!SerialDate.isValidWeekdayCode(targetWeekday)) {  // 第628~660行 可以工作，不过有点复杂了。经过一番思考，了解它的功能后[G21理解算法]，
            throw new IllegalArgumentException(               // 我就能够使用解释临时变量模式来简化它[G19使用解释性变量]，使其更为清晰。我还将它从
                "Invalid day-of-the-week code."               // 从静态方法改为实体方法[G18不恰当的静态方法]，并删除了重复的实体方法[G5重复] 第997~1008行
            );                                                // 《代码整洁之道》P264~P265
        }

        // find the date...
        final int adjust;
        final int baseDOW = base.getDayOfWeek(); // 星期日 0，星期一 1，星期二 2，星期三 3，星期四 4，星期五 5，星期六 6，到 7 变 0。如星期三 getDayOfWeek() 返回 4
        if (baseDOW > targetWeekday) {
            adjust = Math.min(0, targetWeekday - baseDOW);
        }
        else {
            adjust = -7 + Math.max(0, targetWeekday - baseDOW);
        }

        return SerialDate.addDays(adjust, base);

    }

    /**
     * Returns the earliest date that falls on the specified day-of-the-week
     * and is AFTER the base date.
     *
     * @param targetWeekday  a code for the target day-of-the-week.
     * @param base  the base date.
     *
     * @return the earliest date that falls on the specified day-of-the-week
     *         and is AFTER the base date.
     */
    public static SerialDate getFollowingDayOfWeek(final int targetWeekday,
                                                   final SerialDate base) { // => DayDate.getFollowingDayOfWeek()

        // check arguments...
        if (!SerialDate.isValidWeekdayCode(targetWeekday)) {  // 对第662~693行 也如法炮制 《代码整洁之道》P265
            throw new IllegalArgumentException(
                "Invalid day-of-the-week code."
            );
        }

        // find the date...
        final int adjust;
        final int baseDOW = base.getDayOfWeek();
        if (baseDOW > targetWeekday) { // 典型的边界条件错误，应该是 if (baseDOW >= targetWeekday) {
            adjust = 7 + Math.min(0, targetWeekday - baseDOW);
        }
        else {
            adjust = Math.max(0, targetWeekday - baseDOW);
        }

        return SerialDate.addDays(adjust, base);
    }

    /**
     * Returns the date that falls on the specified day-of-the-week and is
     * CLOSEST to the base date.
     *
     * @param targetDOW  a code for the target day-of-the-week.
     * @param base  the base date.
     *
     * @return the date that falls on the specified day-of-the-week and is
     *         CLOSEST to the base date.
     */
    public static SerialDate getNearestDayOfWeek(final int targetDOW,
                                                 final SerialDate base) { // => DayDate.getNearestDayOfWeek()

        // check arguments...
        if (!SerialDate.isValidWeekdayCode(targetDOW)) { // 第695~726行 这个函数是我们之前修改过的。我之前所做的修改和前两个函数没有保持一致[G11前后不一致]，
            throw new IllegalArgumentException(          // 所以我们将它改为和这两个函数保持一致，并且使用解释临时变量模式[G19使用解释性变量]来阐明算法。 《代码整洁之道》P265
                "Invalid day-of-the-week code."
            );
        }

        // find the date... 测试失败算法错误
        final int baseDOW = base.getDayOfWeek(); // final int delta = targetDOW - base.getDayOfWeek(); // 《代码整洁之道》P254
        int adjust = -Math.abs(targetDOW - baseDOW); // int positiveDelta = delta + 7; int adjust = positiveDelta % 7;
        if (adjust >= 4) { // if (adjust > 3) {
            adjust = 7 - adjust; // adjust -= 7;
        }
        if (adjust <= -4) { // 这个 if 语句需要全部注释掉
            adjust = 7 + adjust;
        }
        return SerialDate.addDays(adjust, base);

    }

    /**
     * Rolls the date forward to the last day of the month.
     *
     * @param base  the base date.
     *
     * @return a new serial date.
     */
    public SerialDate getEndOfCurrentMonth(final SerialDate base) { // => DayDate.getEndOfMonth()
        final int last = SerialDate.lastDayOfMonth(                 // 第728~740行 方法有点奇怪，因为它获取了 DayDate 参数，从而成为一个依恋[G14特性依赖]其自身类的实体方法。
            base.getMonth(), base.getYYYY()                         // 我将其改为真正的实体方法，并修改了几个名称。 《代码整洁之道》P265
        );
        return SerialDate.createInstance(last, base.getMonth(), base.getYYYY());
    }

    /**
     * Returns a string corresponding to the week-in-the-month code.
     * <P>
     * Need to find a better approach.
     *
     * @param count  an integer code representing the week-in-the-month.
     *
     * @return a string corresponding to the week-in-the-month code.
     */
    public static String weekInMonthToString(final int count) { // 第742~761行 重构 weekInMonthToString 的过程非常有趣。利用 IDE 的重构工具，我先将其移到我之前创建的 WeekInMonth 枚举中，
                                                                // 再将其重命名为 toString()。接着，我把它从静态方法改为实体方法。所有的测试都通过了。（你能猜到我打算做什么吗？）
        switch (count) {                                        // 接下来，我删除了整个方法！有5个断言失败了（BobsSerialDateTest 第411~415行，见代码清单 B-4）。
            case SerialDate.FIRST_WEEK_IN_MONTH : return "First";   // 我改动了这些代码，让它们使用枚举元素的名称（FIRST、SECOND...）。全部测试都通过了。你知道为什么吗？你是否知道为什么这些步骤
            case SerialDate.SECOND_WEEK_IN_MONTH : return "Second"; // 都是必要的吗？重构工具确保之前对 weekInMonthToString 方法调用现在都调用 weekInMonth 枚举元素的 toString 方法，全部
            case SerialDate.THIRD_WEEK_IN_MONTH : return "Third";   // 枚举元素都以返回其名称的形式实现了 toString 方法...
            case SerialDate.FOURTH_WEEK_IN_MONTH : return "Fourth"; // 我不幸有点聪明过头了。经过这一套美妙的重构，我终于意识到，这个函数的唯一调用者，是我刚修改的测试，所以我删除了这些测试。
            case SerialDate.LAST_WEEK_IN_MONTH : return "Last";     // 该函数没有调用，删除该函数及其测试。 《代码整洁之道》P266
            default :
                return "SerialDate.weekInMonthToString(): invalid code."; // throw new IllegalArgumentException();
        }

    }

    /**
     * Returns a string representing the supplied 'relative'.
     * <P>
     * Need to find a better approach.
     *
     * @param relative  a constant representing the 'relative'.
     *
     * @return a string representing the supplied 'relative'.
     */
    public static String relativeToString(final int relative) { // 第765~781行 愚我一次，是你之耻。愚我两次，是我这耻！所以，在判定除测试之外没有人调用过
                                                                // relativeToString 方法后，我就删除了该函数及其测试。 《代码整洁之道》P266
        switch (relative) {
            case SerialDate.PRECEDING : return "Preceding";
            case SerialDate.NEAREST : return "Nearest";
            case SerialDate.FOLLOWING : return "Following";
            default : return "ERROR : Relative To String"; // throw new IllegalArgumentException();
        }

    }

    /**
     * Factory method that returns an instance of some concrete subclass of
     * {@link SerialDate}.
     *
     * @param day  the day (1-31).
     * @param month  the month (1-12).
     * @param yyyy  the year (in the range 1900 to 9999).
     *
     * @return An instance of {@link SerialDate}.
     */
    public static SerialDate createInstance(final int day, final int month,
                                            final int yyyy) {
        return new SpreadsheetDate(day, month, yyyy);
    }

    /**
     * Factory method that returns an instance of some concrete subclass of
     * {@link SerialDate}.
     *
     * @param serial  the serial number for the day (1 January 1900 = 2).
     *
     * @return a instance of SerialDate.
     */
    public static SerialDate createInstance(final int serial) {
        return new SpreadsheetDate(serial);
    }

    /**
     * Factory method that returns an instance of a subclass of SerialDate.
     *
     * @param date  A Java date object.
     *
     * @return a instance of SerialDate.
     */
    public static SerialDate createInstance(final java.util.Date date) {

        final GregorianCalendar calendar = new GregorianCalendar();
        calendar.setTime(date);
        return new SpreadsheetDate(calendar.get(Calendar.DATE),
                            calendar.get(Calendar.MONTH) + 1,
                                   calendar.get(Calendar.YEAR));

    }

    /**
     * Returns the serial number for the date, where 1 January 1900 = 2 (this
     * corresponds, almost, to the numbering system used in Microsoft Excel for
     * Windows and Lotus 1-2-3).
     *
     * @return the serial number for the date.
     */
    public abstract int toSerial(); // 第829~836行 前文《代码整洁之道》P264我曾把其名改为 toOrdinal()，
                                    // 以现在的情形看，我决定把名称改为 getOrdinalDay()《代码整洁之道》P266
    /**
     * Returns a java.util.Date.  Since java.util.Date has more precision than
     * SerialDate, we need to define a convention for the 'time of day'.
     *
     * @return this as <code>java.util.Date</code>.
     */
    public abstract java.util.Date toDate(); // 第838~844行 它将 DayDate 转换为 java.util.Date。这个方法为何是抽象的？查看其在 SpreadsheetDate 中的
                                             // 实现（第198~207行，见代码清单B-5），可以看到它并不依赖该类的实现[G6在错误的抽象层级上的代码]，所以，我把它往上推了。 《代码整洁之道》P266
    /**
     * Return a description of the date.
     *
     * @return a description of the date.
     */
    public String getDescription() {
        return this.description;
    }

    /**
     * Sets the description for the date.
     *
     * @param description  the description for this date (<code>null</code> permitted).
     */
    public void setDescription(final String description) {
        this.description = description;
    }

    /**
     * Converts the date to a string.
     *
     * @return  a string representation of the date.
     */
    public String toString() {
        return getDayOfMonth() + "-" + SerialDate.monthCodeToString(getMonth())
                               + "-" + getYYYY();
    }

    /**
     * Returns the year (assume a valid range of 1900 to 9999).
     *
     * @return the year.
     */
    public abstract int getYYYY();

    /**
     * Returns the month (January = 1, February = 2, March = 3).
     *
     * @return the month of the year.
     */
    public abstract int getMonth();

    /**
     * Returns the day of the month.
     *
     * @return the day of the month.
     */
    public abstract int getDayOfMonth();

    /**                               // getDayOfWeek 是另一个应该从 SpreadsheetDate 中提炼出来的方法。它有逻辑上的依赖。
     * Returns the day of the week.   // 算法本身也该有一小部分依赖实现。所以在 DayDate 中创建了一全名为 getDayOfWeekForOrdinalZero
     *                                // 的抽象方法，并在 SpreadsheetDate 中实现它。上移到 DayDate 中，并调用 getOrdinalDay() 和
     * @return the day of the week.   // getDayOfWeekForOrdinalZero()。 《代码整洁之道》P266
     */                               // 仔细阅读 第885~899行 的注释，这样的重复有必要吗？通常，我会删除这类的注释。《代码整洁之道》P266
    public abstract int getDayOfWeek();

    /**
     * Returns the difference (in days) between this date and the specified
     * 'other' date.
     * <P>
     * The result is positive if this date is after the 'other' date and
     * negative if it is before the 'other' date.
     *
     * @param other  the date being compared to.
     *
     * @return the difference between this and the other date.
     */
    public abstract int compare(SerialDate other); // 第902~913行，同样该抽象方法是不恰当的[G6在错误的抽象层级上的代码]，我将其实现上移到 DayDate，其名称也不足够有沟通意义[N1]。
                                                   // 方法实际上返回的是自参数日期以来的天数，所以我把名称改为 daysSince。我还注意该方法没有测试，就为它编写了测试。 《代码整洁之道》P266~267
    /**
     * Returns true if this SerialDate represents the same date as the
     * specified SerialDate.
     *
     * @param other  the date being compared to.
     *
     * @return <code>true</code> if this SerialDate represents the same date as
     *         the specified SerialDate.
     */
    public abstract boolean isOn(SerialDate other); // 第915~980行，isOn、isBefore、isOnOrBefore、isAfter、isOnOrAfter、isInRange，6个抽象方法全部在 DayDate 中实现。 《代码整洁之道》P267

    /**
     * Returns true if this SerialDate represents an earlier date compared to
     * the specified SerialDate.
     *
     * @param other  The date being compared to.
     *
     * @return <code>true</code> if this SerialDate represents an earlier date
     *         compared to the specified SerialDate.
     */
    public abstract boolean isBefore(SerialDate other); // 抽象方法全部在 DayDate 中实现。 《代码整洁之道》P267

    /**
     * Returns true if this SerialDate represents the same date as the
     * specified SerialDate.
     *
     * @param other  the date being compared to.
     *
     * @return <code>true</code> if this SerialDate represents the same date
     *         as the specified SerialDate.
     */
    public abstract boolean isOnOrBefore(SerialDate other); // 抽象方法全部在 DayDate 中实现。 《代码整洁之道》P267

    /**
     * Returns true if this SerialDate represents the same date as the
     * specified SerialDate.
     *
     * @param other  the date being compared to.
     *
     * @return <code>true</code> if this SerialDate represents the same date
     *         as the specified SerialDate.
     */
    public abstract boolean isAfter(SerialDate other); // 抽象方法全部在 DayDate 中实现。 《代码整洁之道》P267

    /**
     * Returns true if this SerialDate represents the same date as the
     * specified SerialDate.
     *
     * @param other  the date being compared to.
     *
     * @return <code>true</code> if this SerialDate represents the same date
     *         as the specified SerialDate.
     */
    public abstract boolean isOnOrAfter(SerialDate other); // 抽象方法全部在 DayDate 中实现。 《代码整洁之道》P267

    /**
     * Returns <code>true</code> if this {@link SerialDate} is within the
     * specified range (INCLUSIVE).  The date order of d1 and d2 is not
     * important.
     *
     * @param d1  a boundary date for the range.
     * @param d2  the other boundary date for the range.
     *
     * @return A boolean.
     */
    public abstract boolean isInRange(SerialDate d1, SerialDate d2); // 抽象方法全部在 DayDate 中实现。 《代码整洁之道》P267

    /**
     * Returns <code>true</code> if this {@link SerialDate} is within the
     * specified range (caller specifies whether or not the end-points are
     * included).  The date order of d1 and d2 is not important.
     *
     * @param d1  a boundary date for the range.
     * @param d2  the other boundary date for the range.
     * @param include  a code that controls whether or not the start and end
     *                 dates are included in the range.
     *
     * @return A boolean.
     */
    public abstract boolean isInRange(SerialDate d1, SerialDate d2,
                                      int include); // 第982~995行，最后一个 isInRange 也需要推到上一层并重构之。那个 switch 语句有点儿丑陋[G23用多态取代if/else或switch/case]，
                                                    // 可以把那些条件判断移到 DateInterval 枚举中去。 《代码整洁之道》P267
    /**
     * Returns the latest date that falls on the specified day-of-the-week and
     * is BEFORE this date.
     *
     * @param targetDOW  a code for the target day-of-the-week.
     *
     * @return the latest date that falls on the specified day-of-the-week and
     *         is BEFORE this date.
     */
    public SerialDate getPreviousDayOfWeek(final int targetDOW) { // 在第628~660行处优化时，删除了第997~1008行 《代码整洁之道》P265
        return getPreviousDayOfWeek(targetDOW, this);
    }

    /**
     * Returns the earliest date that falls on the specified day-of-the-week
     * and is AFTER this date.
     *
     * @param targetDOW  a code for the target day-of-the-week.
     *
     * @return the earliest date that falls on the specified day-of-the-week
     *         and is AFTER this date.
     */
    public SerialDate getFollowingDayOfWeek(final int targetDOW) {
        return getFollowingDayOfWeek(targetDOW, this);
    }

    /**
     * Returns the nearest date that falls on the specified day-of-the-week.
     *
     * @param targetDOW  a code for the target day-of-the-week.
     *
     * @return the nearest date that falls on the specified day-of-the-week.
     */
    public SerialDate getNearestDayOfWeek(final int targetDOW) {
        return getNearestDayOfWeek(targetDOW, this);
    }

}