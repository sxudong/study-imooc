package com.payroll.transaction;

import com.payroll.emp.Employee;
import com.payroll.paymentMethod.PaymentMethod;

public abstract class ChangeMethodTransaction extends ChangeEmployeeTransaction{

    public ChangeMethodTransaction(int empId) {
        super(empId);
    }

    @Override
    public void change(Employee employee) {
        employee.setPaymentMethod(getPaymentMethod());
    }

   public abstract PaymentMethod getPaymentMethod();
}
