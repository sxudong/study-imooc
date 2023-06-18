package com.payroll.abstractTransaction;

import com.payroll.payrollDomain.Affiliation;
import com.payroll.payrollDomain.Employee;

/**
 * 图19.26  P203  程序19.30 P205
 * 再次使用了 Template method 模式来选择应该传给 Employee 对象的 Affiliation 派生对象。
 */
public abstract class ChangeAffiliationTransaction extends ChangeEmployeeTransaction {

    public ChangeAffiliationTransaction(int empId) {
        super(empId);
    }

    @Override
    public void change(Employee employee) {
        recordMembership(employee);
        employee.setAffiliation(getAffiliation());
    }

    // 记录成员关系
    protected abstract void recordMembership(Employee employee);
    protected abstract Affiliation getAffiliation();

}
