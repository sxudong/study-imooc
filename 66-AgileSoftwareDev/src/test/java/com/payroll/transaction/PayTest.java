package com.payroll.transaction;

import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;
import com.payroll.util.Paycheck;
import org.junit.Assert;
import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


public class PayTest extends BaseTest {


    /**
     * 按月领取薪水
     */
    @Test
    public void paySingleSalariedEmployed() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        AddSalariedEmployee addSalariedEmployee = new AddSalariedEmployee(empId, name, address, 1000.0D);
        addSalariedEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Date payDate = getPayDate(2019, 5, 31); // 五月份最后一天
        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNotNull(pc);
        Assert.assertTrue(pc.getPayPeriodEndDate() == payDate);
        Assert.assertEquals("Hold", pc.getDisposition());
        Assert.assertEquals(1000.0D, pc.getGrossPay(), 0.01);
        Assert.assertEquals(0.00, pc.getDeductions(), 0.01);
        Assert.assertEquals(1000.0D, pc.getNetPay(), 0.01);

    }

    /**
     * 按月领取薪水 -- 错误的发薪日
     */
    @Test
    public void paySingleSalariedEmployedOnWrongDate() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        AddSalariedEmployee addSalariedEmployee = new AddSalariedEmployee(empId, name, address, 1000.0D);
        addSalariedEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Date payDate = getPayDate(2019, 5, 30); // 倒数第二天，非发薪日
        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        Paycheck pc = pt.getPaycheck(empId);
        Assert.assertNull(pc);
    }

    /**
     * 小时工，无时间卡的情况
     */
    @Test
    public void paySingleHourlyEmployedNoTimeCards() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Date payDate = getPayDate(2019, 5, 3); // Friday
        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        validatePaycheck(pt, empId, payDate, 0.0);
    }

    /**
     * 小时工，一张时间卡
     */
    @Test
    public void paySingleHourlyEmployedOneTimeCards() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Date payDate = getPayDate(2019, 5, 3); // Friday
        TimeCardTransaction tct = new TimeCardTransaction(payDate, 2.0, empId);
        tct.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        validatePaycheck(pt, empId, payDate, 30.50);
    }

    /**
     * 小时工，一张时间卡，有加班
     */
    @Test
    public void paySingleHourlyEmployedOverTimeOneTimeCards() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Date payDate = getPayDate(2019, 5, 3); // Friday
        double hour = 10;
        TimeCardTransaction tct = new TimeCardTransaction(payDate, hour, empId);
        tct.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        validatePaycheck(pt, empId, payDate, (8 + (hour - 8) * 1.5) * hourlyRate);
    }

    /**
     * 小时工，两张时间卡
     */
    @Test
    public void paySingleHourlyEmployedTwoTimeCards() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Date payDate = getPayDate(2019, 5, 3); // Friday

        TimeCardTransaction tct = new TimeCardTransaction(payDate, 2.0, empId);
        tct.execute();

        TimeCardTransaction tct2 = new TimeCardTransaction(getPayDate(2019, 5, 2), 5.0, empId);
        tct2.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        validatePaycheck(pt, empId, payDate, 7 * hourlyRate);
    }

    /**
     * 小时工，两张时间卡，只对当前支付期内的时间卡进行计算
     */
    @Test
    public void paySingleHourlyEmployedWithTimeCardsSpanningTwoPayPeriods() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Date payDate = getPayDate(2019, 5, 3); // Friday

        TimeCardTransaction tct = new TimeCardTransaction(payDate, 2.0, empId);
        tct.execute();

        TimeCardTransaction tct2 = new TimeCardTransaction(getPayDate(2019, 4, 2), 5.0, empId);
        tct2.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        validatePaycheck(pt, empId, payDate, 2 * hourlyRate);
    }

    /**
     * 小时工，不是发薪日
     */
    @Test
    public void paySingleHourlyEmployedOnWrongDate() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertEquals(name, employee.getEmpName());

        Date payDate = getPayDate(2019, 5, 1); // Not Friday，It's Wednesday
        double hour = 10;
        TimeCardTransaction tct = new TimeCardTransaction(payDate, hour, empId);
        tct.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

        Paycheck paycheck = pt.getPaycheck(empId);
        Assert.assertNull(paycheck);
    }

    /**
     * 计算会费和有服务费
     */
    @Test
    public void hourlyUnionMemberServiceCharge() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        int memberId = 7734;
        ChangeMemberTransaction cmt = new ChangeMemberTransaction(empId, memberId, 9.42);
        cmt.execute();

        Date payDate = getPayDate(2019, 5, 3);
        ServiceChargeTransaction sct = new ServiceChargeTransaction(memberId, payDate, 19.42);
        sct.execute();

        TimeCardTransaction tct = new TimeCardTransaction(payDate, 8, empId);
        tct.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

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
     */
    @Test
    public void serviceChargeSpanningMultiplePayPeriods() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double hourlyRate = 15.25;
        AddHourlyEmployee hourlyEmployee = new AddHourlyEmployee(empId, name, address, hourlyRate);
        hourlyEmployee.execute();

        int memberId = 7734;
        ChangeMemberTransaction cmt = new ChangeMemberTransaction(empId, memberId, 9.42);
        cmt.execute();

        Date earlyPayDate = getPayDate(2019, 4, 26);// previous Friday
        Date payDate = getPayDate(2019, 5, 3);// previous Friday
        Date laterPayDate = getPayDate(2019, 5, 10);// next Friday

        ServiceChargeTransaction sct = new ServiceChargeTransaction(memberId, payDate, 19.42);
        sct.execute();
        ServiceChargeTransaction earlySct = new ServiceChargeTransaction(memberId, earlyPayDate, 100);
        earlySct.execute();
        ServiceChargeTransaction laterSct = new ServiceChargeTransaction(memberId, laterPayDate, 200);
        laterSct.execute();

        TimeCardTransaction tct = new TimeCardTransaction(payDate, 8, empId);
        tct.execute();

        PaydayTransaction pt = new PaydayTransaction(payDate);
        pt.execute();

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
        String name = "Bob";
        String address = "Home";
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, name, address, salary, commissionRate);
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
     * 带提成的雇员 一张销售凭条
     */
    @Test
    public void paySingleCommissionedEmployedOneSalesReceipt() {
        int empId = 1;
        String name = "Bob";
        String address = "Home";
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, name, address, salary, commissionRate);
        commissionedEmployee.execute();

        Date payDate = getPayDate(2019, 5, 3);
        Date earlyDay = getPayDate(2019, 5, 2);
        double salesAmount = 1884.25;
        SalesReceiptTransaction srt = new SalesReceiptTransaction(earlyDay, salesAmount, empId);
        srt.execute();

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
        String name = "Bob";
        String address = "Home";
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, name, address, salary, commissionRate);
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
        String name = "Bob";
        String address = "Home";
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, name, address, salary, commissionRate);
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
        String name = "Bob";
        String address = "Home";
        double salary = 1500.25;
        double commissionRate = 0.4;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, name, address, salary, commissionRate);
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
    }

}
