package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.HourlyClassification;
import com.payroll.payrollImpl.TimeCard;
import com.payroll.transactionImpl.*;
import com.payroll.util.Paycheck;
import org.junit.Assert;
import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


public class PayTest extends BaseTest {


    /**
     * 按月领取薪水
     * 程序19.40 简单的测试用例。向数据库增加一个钟点雇员，然后支付他薪水。
     * 由于没有任何的时间卡，所以我们期望支付票上的值为 0。 P212
     */
    @Test
    public void paySingleSalariedEmployed() {
        int empId = 1;
        AddSalariedEmployee addSalariedEmployee = new AddSalariedEmployee(empId, "Bob", "Home", 1000.0D);
        addSalariedEmployee.execute(); // 新增一个按月领取薪水工

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Date payDate = getPayDate(2019, 5, 31); // 五月份最后一天
        PaydayTransaction pt = new PaydayTransaction(payDate);   // 传入的日期会被用来判断是否是发薪日
        pt.execute(); // 支付薪水

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNotNull(pc);
        Assert.assertTrue(pc.getPayPeriodEndDate() == payDate);
        Assert.assertEquals("Hold", pc.getDisposition());
        Assert.assertEquals(1000.0D, pc.getGrossPay(), 0.01); // 总工资
        Assert.assertEquals(0.00, pc.getDeductions(), 0.01);  // 扣除
        Assert.assertEquals(1000.0D, pc.getNetPay(), 0.01);   // 实付工资

    }

    /**
     * 按月领取薪水 -- 错误的发薪日
     */
    @Test
    public void paySingleSalariedEmployedOnWrongDate() {
        int empId = 1;
        AddSalariedEmployee addSalariedEmployee = new AddSalariedEmployee(empId, "Bob", "Home", 1000.0D);
        addSalariedEmployee.execute(); // 新增一个按月领取薪水工

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Date payDate = getPayDate(2019, 5, 30); // 倒数第二天，非发薪日
        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute(); // 支付薪水

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNull(pc);
    }

    /**
     * 小时工，无时间卡的情况
     * 程序19.41 测试用例验证是否可以支付给具有单一时间卡的雇员薪水。P212
     */
    @Test
    public void paySingleHourlyEmployedNoTimeCards() {
        int empId = 1;
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute(); // 新增一个钟点雇员

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Date payDate = getPayDate(2019, 5, 3); // Friday
        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute(); // 支付薪水

        validatePaycheck(pt, empId, payDate, 0.0);
    }

    /**
     * 小时工，一张时间卡
     * 程序19.42 测试用例验证是否可以对超出8小时的时间卡进行支付。
     */
    @Test
    public void paySingleHourlyEmployedOneTimeCards() {
        int empId = 1;
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute(); // 新增一个钟点雇员

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Date payDate = getPayDate(2019, 5, 3); // Friday
        TimeCardTransaction tct = new TimeCardTransaction(payDate, 2.0, empId);
        tct.execute(); // 添加时间卡

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute(); // 支付薪水

        validatePaycheck(pt, empId, payDate, 30.50); // 2 * 15.25

        TimeCard tc = ((HourlyClassification) employee.getItsClassification()).getTimeCard(payDate);
        Assert.assertNotNull(tc);
        Assert.assertEquals(2, tc.getHours(), 0.01D);
    }

    /**
     * 小时工，一张时间卡，有加班
     */
    @Test
    public void paySingleHourlyEmployedOverTimeOneTimeCards() {
        int empId = 1;
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute(); // 新增一个钟点雇员

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Date payDate = getPayDate(2001, 11, 9); // Friday
        double hour = 10;
        TimeCardTransaction tct = new TimeCardTransaction(payDate, hour, empId);
        tct.execute(); // 添加时间卡

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute(); // 支付薪水

        validatePaycheck(pt, empId, payDate, (8 + (hour - 8) * 1.5) * hourlyRate); // 加班1.5倍薪水
    }

    /**
     * 小时工，两张时间卡
     * 程序19.43 测试用例证实了系统可以为具有多个时间卡的雇员计算薪水。P213
     */
    @Test
    public void paySingleHourlyEmployedTwoTimeCards() {
        int empId = 1;
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute(); // 新增一个钟点雇员

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Date payDate1 = getPayDate(2001, 11, 9); // Friday
        TimeCardTransaction tct = new TimeCardTransaction(payDate1, 2.0, empId);
        tct.execute(); // 添加时间卡

        Date payDate2 = getPayDate(2001, 11, 8); // 星期四
        TimeCardTransaction tct2 = new TimeCardTransaction(payDate2, 5.0, empId);
        tct2.execute(); // 添加时间卡

        PaydayTransaction pt = new PaydayTransaction(payDate1); // 传入的日期会被用来判断是否是发薪日
        pt.execute(); // 支付薪水

        validatePaycheck(pt, empId, payDate1, 7 * hourlyRate); // 工作时间超过8小时，加班费才按1.5倍计算
    }

    /**
     * 小时工，两张时间卡，只对当前支付期内的时间卡进行计算
     * 程序19.44 测试用例证实了系统只为当前支付期内的时间卡对雇员进行支付薪水。P214
     */
    @Test
    public void paySingleHourlyEmployedWithTimeCardsSpanningTwoPayPeriods() {
        int empId = 1;
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute(); // 新增一个钟点雇员

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Date payDate1 = getPayDate(2001, 11, 9); // Friday
        TimeCardTransaction tct = new TimeCardTransaction(payDate1, 2.0, empId);
        tct.execute(); // 添加时间卡

        Date payDate2 = getPayDate(2001, 11, 2);
        TimeCardTransaction tct2 = new TimeCardTransaction(payDate2, 5.0, empId);
        tct2.execute(); // 添加时间卡

        PaydayTransaction pt = new PaydayTransaction(payDate1);
        pt.execute(); // 支付薪水

        validatePaycheck(pt, empId, payDate1, 2 * hourlyRate);
    }

    /**
     * 小时工，不是发薪日
     * 程序19.42 测试用例证实了如果 PaydayTransaction 不是使用周五作为参数构造的，系统就不支付钟点雇员。P213
     */
    @Test
    public void paySingleHourlyEmployedOnWrongDate() {
        int empId = 1;
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute(); // 新增一个钟点雇员

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals("Bob", employee.getItsName());

        Date payDate = getPayDate(2001, 11, 8); // Not Friday，It's Wednesday
        double hour = 10;
        TimeCardTransaction tct = new TimeCardTransaction(payDate, hour, empId);
        tct.execute(); // 添加时间卡

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute(); // 支付薪水

        Paycheck paycheck = pt.getPaycheck(empId);
        Assert.assertNull(paycheck);
    }

    /**
     * 计算会费和服务费的功能
     * 程序19.47 P215
     *    该测试用例增加一个带薪雇员，把它转变一个协会成员，然后支付该雇员薪水，并确保从雇员的薪水中扣除了会费。
     */
    @Test
    public void testSalariedUnionMemberDues() {
        int empId = 1;
        double salary = 1000;
        AddSalariedEmployee hourlyEmployee = new AddSalariedEmployee(empId, "Bob", "Home", salary);
        hourlyEmployee.execute();

        int memberId = 7734;
        ChangeMemberTransaction cmt = new ChangeMemberTransaction(empId, memberId, 9.42); // 转变成一个协会成员
        cmt.execute();

        // 有 5 个星期五 x 9.42 = 47.1
        Date payDate = getPayDate(2001, 11, 30);
        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        validatePaycheck2(pt, empId, payDate, 1000);
    }


    /**
     * 计算会费和有服务费
     * 程序19.5.1 证实服务费用被正确地扣除。  P217
     */
    @Test
    public void hourlyUnionMemberServiceCharge() {
        int empId = 1;
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bob", "Home", hourlyRate);
        hourlyEmployee.execute();

        int memberId = 7734;
        ChangeMemberTransaction cmt = new ChangeMemberTransaction(empId, memberId, 9.42); // 转变成一个协会成员
        cmt.execute();

        Date payDate = getPayDate(2019, 5, 3);
        ServiceChargeTransaction sct = new ServiceChargeTransaction(memberId, payDate, 19.42); // 服务费
        sct.execute();

        TimeCardTransaction tct = new TimeCardTransaction(payDate, 8, empId);
        tct.execute(); // 添加时间卡

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute(); // 支付薪水

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNotNull(pc);
        Assert.assertEquals("Hold", pc.getDisposition());
        Assert.assertTrue(pc.getPayPeriodEndDate() == payDate);
        Assert.assertEquals(8 * hourlyRate, pc.getGrossPay(), 0.001);
        Assert.assertEquals(9.42 + 19.42, pc.getDeductions(), 0.001);
        Assert.assertEquals(8 * hourlyRate - 9.42 - 19.42, pc.getNetPay(), 0.001);

    }

    /**
     * 计算会费和有服务费，非支付期内的服务费用不需要被扣除
     * 程序19.52 P217
     *   该测试用例要证实当前支付期间的服务费没有被扣除。
     */
    @Test
    public void serviceChargeSpanningMultiplePayPeriods() {
        int empId = 1;
        double hourlyRate = 15.24;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, "Bill", "Home", hourlyRate);
        hourlyEmployee.execute();

        int memberId = 7734;
        ChangeMemberTransaction cmt = new ChangeMemberTransaction(empId, memberId, 9.42);
        cmt.execute();

        Date earlyPayDate = getPayDate(2019, 4, 26); // previous Friday
        Date payDate = getPayDate(2019, 5, 3);       // previous Friday
        Date laterPayDate = getPayDate(2019, 5, 10); // next Friday

        ServiceChargeTransaction sct = new ServiceChargeTransaction(memberId, payDate, 19.42); // 服务费
        sct.execute();
        ServiceChargeTransaction earlySct = new ServiceChargeTransaction(memberId, earlyPayDate, 100); // 服务费
        earlySct.execute();
        ServiceChargeTransaction laterSct = new ServiceChargeTransaction(memberId, laterPayDate, 200); // 服务费
        laterSct.execute();

        TimeCardTransaction tct = new TimeCardTransaction(payDate, 8, empId);
        tct.execute(); // 添加时间卡

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute(); // 支付薪水

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNotNull(pc);
        Assert.assertEquals("Hold", pc.getDisposition());
        Assert.assertTrue(pc.getPayPeriodEndDate() == payDate);
        Assert.assertEquals(8 * hourlyRate, pc.getGrossPay(), 0.001);
        Assert.assertEquals(9.42 + 19.42, pc.getDeductions(), 0.001);
        Assert.assertEquals(8 * hourlyRate - 9.42 - 19.42, pc.getNetPay(), 0.001);

    }

    /**
     * 带提成的雇员 没有销售凭条
     */
    @Test
    public void paySingleCommissionedEmployedNoSalesReceipt() {
        int empId = 1;
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        Date payDate = getPayDate(2019, 5, 3);
        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNotNull(pc);
        Assert.assertEquals("Hold", pc.getDisposition());
        Assert.assertTrue(pc.getPayPeriodEndDate() == payDate);
        Assert.assertEquals(salary, pc.getGrossPay(), 0.001);
        Assert.assertEquals(0, pc.getDeductions(), 0.001);
        Assert.assertEquals(salary, pc.getNetPay(), 0.001);
    }

    /**
     * 带提成的雇员 一张销售凭条 P193
     */
    @Test
    public void paySingleCommissionedEmployedOneSalesReceipt() {
        int empId = 1;
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        Date payDate = getPayDate(2019, 5, 3);
        Date earlyDay = getPayDate(2019, 5, 2);
        double salesAmount = 1884.25;
        SalesReceiptTransaction srt = new SalesReceiptTransaction(earlyDay, salesAmount, empId);
        srt.execute(); // 登记销售凭条操作

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNotNull(pc);
        Assert.assertEquals("Hold", pc.getDisposition());
        Assert.assertTrue(pc.getPayPeriodEndDate() == payDate);
        Assert.assertEquals(salary + commissionRate * salesAmount, pc.getGrossPay(), 0.001);
        Assert.assertEquals(0, pc.getDeductions(), 0.001);
        Assert.assertEquals(salary + commissionRate * salesAmount, pc.getNetPay(), 0.001);
    }

    /**
     * 带提成的雇员 两张张销售凭条
     */
    @Test
    public void paySingleCommissionedEmployedTwoSalesReceipt() {
        int empId = 1;
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        Date earlyDay = getPayDate(2019, 5, 2);
        double salesAmount = 1884.25;
        SalesReceiptTransaction srt = new SalesReceiptTransaction(earlyDay, salesAmount, empId);
        srt.execute();

        Date payDate = getPayDate(2019, 5, 3);
        double salesAmount2 = 1668.50;
        SalesReceiptTransaction srt2 = new SalesReceiptTransaction(payDate, salesAmount2, empId);
        srt2.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNotNull(pc);
        Assert.assertEquals("Hold", pc.getDisposition());
        Assert.assertTrue(pc.getPayPeriodEndDate() == payDate);
        Assert.assertEquals(salary + commissionRate * (salesAmount + salesAmount2), pc.getGrossPay(), 0.001);
        Assert.assertEquals(0, pc.getDeductions(), 0.001);
        Assert.assertEquals(salary + commissionRate * (salesAmount + salesAmount2), pc.getNetPay(), 0.001);
    }

    /**
     * 带提成的雇员 两张张销售凭条 只对当前支付期内的时间卡进行计算
     */
    @Test
    public void paySingleCommissionedEmployedWithSalesReceiptsSpanningTwoPayPeriods() {
        int empId = 1;
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        Date earlyDay = getPayDate(2019, 4, 9);
        double salesAmount = 1884.25;
        SalesReceiptTransaction srt1 = new SalesReceiptTransaction(earlyDay, salesAmount, empId);
        srt1.execute();

        Date payDate = getPayDate(2019, 5, 3);
        double salesAmount2 = 1668.50;
        SalesReceiptTransaction srt2 = new SalesReceiptTransaction(payDate, salesAmount2, empId);
        srt2.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNotNull(pc);
        Assert.assertEquals("Hold", pc.getDisposition());
        Assert.assertTrue(pc.getPayPeriodEndDate() == payDate);
        Assert.assertEquals(salary + commissionRate * salesAmount2, pc.getGrossPay(), 0.001);
        Assert.assertEquals(0, pc.getDeductions(), 0.001);
        Assert.assertEquals(salary + commissionRate * salesAmount2, pc.getNetPay(), 0.001);
    }

    /**
     * 带提成的雇员，不是发薪日
     */
    @Test
    public void paySingleCommissionedEmployedOnWrongDate() {
        int empId = 1;
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Bob", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        Date payDate = getPayDate(2019, 5, 1); // Not Friday，It's Wednesday
        Date earlyDay = getPayDate(2019, 4, 227);
        double salesAmount = 1884.25;
        SalesReceiptTransaction srt = new SalesReceiptTransaction(earlyDay, salesAmount, empId);
        srt.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNull(pc);
    }

    private void validatePaycheck(PaydayTransaction pt, int empId, Date payDate, double pay) {
        Paycheck paycheck = pt.getPaycheck(empId);
        Assert.assertNotNull(paycheck);
        Assert.assertEquals("Hold", paycheck.getDisposition());
        Assert.assertEquals(paycheck.getPayPeriodEndDate(), payDate);
        Assert.assertEquals(pay, paycheck.getGrossPay(), 0.01);
        Assert.assertEquals(0.0, paycheck.getDeductions(), 0.01);
        Assert.assertEquals(pay, paycheck.getNetPay(), 0.01);
    }

    private void validatePaycheck2(PaydayTransaction pt, int empId, Date payDate, double pay) {
        Paycheck paycheck = pt.getPaycheck(empId);
        Assert.assertNotNull(paycheck);
        Assert.assertEquals("Hold", paycheck.getDisposition());
        Assert.assertEquals(paycheck.getPayPeriodEndDate(), payDate);
        Assert.assertEquals(pay, paycheck.getGrossPay(), 0.01);
        Assert.assertEquals(47.1, paycheck.getDeductions(), 0.01);
        Assert.assertEquals(952.9, paycheck.getNetPay(), 0.01);
    }

    private Date getPayDate(int year, int month, int day) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, year);
        calendar.set(Calendar.MONTH, month - 1);
        calendar.set(Calendar.DAY_OF_MONTH, day);
        return calendar.getTime();
    }

    public static void main(String[] args) {
        Date payDate = new PayTest().getPayDate(2019, 5, 31);
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        System.out.println(sf.format(payDate));
        System.out.println(Calendar.getInstance().get(Calendar.MONTH));
        System.out.println(Calendar.getInstance().get(Calendar.DAY_OF_MONTH));
        System.out.println(Calendar.getInstance().get(Calendar.DAY_OF_WEEK));


        //获取Calendar实例
        Calendar c = Calendar.getInstance();

        //对指定字段进行向前减向后加操作
        c.add(Calendar.YEAR, -1);
        System.out.println(c.getTime());

        Calendar c2 = Calendar.getInstance();
        c2.add(Calendar.MONTH, 2);
        System.out.println(c2.getTime());

        Calendar c3 = Calendar.getInstance();
        c3.add(Calendar.DAY_OF_MONTH, -3);
        System.out.println(c3.getTime());

        Calendar c4 = Calendar.getInstance();
        c4.add(Calendar.DAY_OF_YEAR, -3);
        System.out.println(c4.getTime());
    }
}
