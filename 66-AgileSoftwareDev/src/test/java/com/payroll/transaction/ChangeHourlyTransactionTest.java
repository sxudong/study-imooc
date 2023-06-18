package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.HourlyClassification;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollImpl.WeeklySchedule;
import com.payroll.transactionImpl.AddCommissionedEmployee;
import com.payroll.transactionImpl.ChangeHourlyTransaction;
import org.junit.Assert;
import org.junit.Test;

/**
 * 19.4.1 更改雇员类别
 * 程序19.24  P201
 *    测试用例中使用 AddCommissionedEmployee 操作创建了一个应支付酬金的雇员。接着，
 *    创建了一个 ChangeHourlyTransaction 对象并执行它。然后，取出已经被更改的雇员
 *    对象并验证它的 PaymentClassification 成员指向的是具有正常每小时报酬的
 *    HourlyClassification 类型的对象，以及它的 PaymentSchedule 成员指向的是
 *    WeeklySchedule 类型的对象。
 */
public class ChangeHourlyTransactionTest extends BaseTest {

    @Test
    public void changeTest() {
        int empId = 1;
        double salary = 1000.00;
        double commissionRate = 88.8;
        AddCommissionedEmployee commissionedEmployee = new AddCommissionedEmployee(empId, "Lance", "Home", salary, commissionRate);
        commissionedEmployee.execute();

        ChangeHourlyTransaction cht = new ChangeHourlyTransaction(empId, 27.5);
        cht.execute();

        Employee employee = PayrollDatabase.getEmployee(empId);
        Assert.assertNotNull(employee);

        PaymentClassification pcf = employee.getItsClassification();
        Assert.assertNotNull(pcf);
        Assert.assertTrue(pcf instanceof HourlyClassification);
        Assert.assertEquals(27.5, ((HourlyClassification) pcf).getHourlyRate(), 0.01);
        Assert.assertTrue(employee.getItsPaymentSchedule() instanceof WeeklySchedule);
    }
}
