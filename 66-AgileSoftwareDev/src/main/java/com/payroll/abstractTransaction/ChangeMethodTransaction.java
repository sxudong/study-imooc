package com.payroll.abstractTransaction;

import com.payroll.payrollDomain.Employee;
import com.payroll.payrollDomain.PaymentMethod;

/**
 * P203
 * 采用 Template method 模式实现机制。用抽象方法 getMethod() 来选择适当的
 * paymentMethod 派生对象，然后把该派生对象传给 Employee 对象。
 */
public abstract class ChangeMethodTransaction extends ChangeEmployeeTransaction {

    public ChangeMethodTransaction(int empId) {
        super(empId);
    }

    @Override
    public void change(Employee employee) {
        employee.setItsPaymentMethod(getMethod());
    }

   protected abstract PaymentMethod getMethod();
}
