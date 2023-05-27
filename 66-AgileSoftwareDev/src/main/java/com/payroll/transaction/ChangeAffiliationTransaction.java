package com.payroll.transaction;

import com.payroll.affiliation.Affiliation;
import com.payroll.emp.Employee;

public abstract class ChangeAffiliationTransaction extends ChangeEmployeeTransaction{

    public ChangeAffiliationTransaction(int empId) {
        super(empId);
    }

    @Override
    public void change(Employee employee) {
        recordMembership(employee);
        employee.setAffiliation(getAffiliation());
    }

    protected abstract void recordMembership(Employee employee);

    protected abstract Affiliation getAffiliation();

}
