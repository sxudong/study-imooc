package com.payroll.abstractTransaction;


import com.payroll.payrollDomain.Employee;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollDomain.PaymentSchedule;

/**
 * 19.4.1 更改雇员类别  程序19.26   P200
 *     再次使用了 Template method 模式。该操作创建一个新的 PaymentClassification 对象，
 * 然后把它传给 Employee 对象。这一点是通过向自己发送 getClassification() 消息完成的。
 * 在 ChangeClassificationTransaction 的每一个派生类中，都要实现 getClassification()
 * 这个抽象方法。
 *
 * 它使用这两个函数的返回值来设置 Employee 的类别以及支付薪水时间表。
 */
public abstract class ChangeClassificationTransaction extends ChangeEmployeeTransaction {

    public ChangeClassificationTransaction(int empId) {
        super(empId);
    }

    @Override
    public void change(Employee employee) {
        employee.setItsClassification(getClassification());
        employee.setItsPaymentSchedule(getSchedule());
    }

    protected abstract PaymentClassification getClassification();
    protected abstract PaymentSchedule getSchedule();
}
