package com.payroll.abstractTransaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionApplication.Transaction;

/**
 * 19.4 更改雇员属性
 * 该基类的下面一层是修改单个属性的类，比如 ChangeNameTransaction 和 ChangeAddressTransaction。
 * 改变雇员类的操作有一个共同的行为，它们都会修改 Employee 对象的同一个字段。
 *
 * 改变支付方式和从属关系的操作雷同。从 ChangeMethodTransaction 类和 ChangeAffiliationTransaction 类
 * 的结构中可以看到这一点。
 *
 * 再次使用 Template Method 模式
 */
public abstract class ChangeEmployeeTransaction implements Transaction { // 共5个子类

    private int empId;

    protected ChangeEmployeeTransaction(int empId) {
        this.empId = empId;
    }

    @Override
    public void execute() {
        Employee employee = PayrollDatabase.getEmployee(empId);
        if(null != employee){
            change(employee);
        }
    }

    protected abstract void change(Employee employee);
}
