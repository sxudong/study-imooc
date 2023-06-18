package com.payroll.abstractTransaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollDomain.PaymentClassification;
import com.payroll.payrollImpl.HoldMethod;
import com.payroll.payrollDomain.PaymentSchedule;
import com.payroll.transactionApplication.Transaction;

/**
 * 19.1.2 使用 Template Method 模式增加雇员操作 P186
 * 参见 图18.1 AddEmployeeTransaction 类层次结构，有3个子类。
 */
public abstract class AddEmployeeTransaction implements Transaction {

    private int empId;
    private String empName;
    private String empAddress;

    public AddEmployeeTransaction(int empId, String empName, String empAddress) {
        this.empId = empId;
        this.empName = empName;
        this.empAddress = empAddress;
    }

    protected abstract PaymentSchedule getPaymentSchedule();

    protected abstract PaymentClassification getPaymentClassification();

    @Override
    public void execute() {
        Employee employee = new Employee(empId, empName, empAddress);
        employee.setItsClassification(getPaymentClassification()); // 支付类别 ：按月支付/带提成的雇员/钟点工
        employee.setItsPaymentMethod(new HoldMethod());
        employee.setItsPaymentSchedule(getPaymentSchedule()); // 每周支付/按月支付/每两周一次支付
        PayrollDatabase.addEmployee(employee);
    }
}
