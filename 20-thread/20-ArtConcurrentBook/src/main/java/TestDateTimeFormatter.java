import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.Temporal;
import java.util.Date;


/**
 * yyyy-MM-dd'T'HH:mm:ss.SSSZZ 和 yyyy-MM-dd'T'HH:mm:ss.SSSXXX 之间的区别？
 * https://www.coder.work/article/5588275
 *
 * X：[-+]##           -08;
 * XX：[-+]####        -0800;
 * XXX：[-+]##:##      -08:00
 */
public class TestDateTimeFormatter {
    public static void main(String[] args) throws ParseException {
        testJavaTime();
        System.out.println(transToUTCDate("23:11:19+08:00")); // Thu Jan 01 13:24:40 CST 1970
    }


    public static void printDate(Temporal t, String format) {
        System.out.println(DateTimeFormatter.ofPattern(format).format(t));
    }

    public static void testJavaTime() {
        ZonedDateTime zdt = ZonedDateTime.now();
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSZ");       //2023-05-04 23:14:24.414+0800
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSZZ");      //2023-05-04 23:14:24.414+0800
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSZZZ");     //2023-05-04 23:14:24.414+0800
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSZZZZ");    //2023-05-04 23:14:24.414GMT+08:00
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSZZZZZ");   //2023-05-04 23:14:24.414+08:00
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSX");       //2023-05-04 23:14:24.414+08
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSXX");      //2023-05-04 23:14:24.414+0800
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSXXX");     //2023-05-04 23:14:24.414+08:00
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSXXXX");    //2023-05-04 23:14:24.414+0800
        printDate(zdt, "yyyy-MM-dd HH:mm:ss.SSSXXXXX");   //2023-05-04 23:14:24.414+08:00
        printDate(zdt, "HH:mm:ssXXX");                    //23:14:24+08:00
    }


    public static String transToNormalDate(String date) {
        LocalDateTime localDate = LocalDateTime.parse(date,DateTimeFormatter.ISO_OFFSET_DATE_TIME);
        String normalDate = localDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        return normalDate;
    }

    public static Date transToUTCDate(String strDate) throws ParseException {
        String myDateString ="13:24:40+08:00";

        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ssXXX");
        Date date = sdf.parse(myDateString);
        return date;
    }
}
