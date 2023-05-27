package com.payroll.transaction;

import com.payroll.affiliation.Affiliation;
import com.payroll.affiliation.UnionAffiliation;
import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;

public class ChangeMemberTransaction extends ChangeAffiliationTransaction {

    private int memberId;

    private double charge;

    public ChangeMemberTransaction(int empId, int memberId, double charge) {
        super(empId);
        this.memberId = memberId;
        this.charge = charge;
    }

    @Override
    protected void recordMembership(Employee employee) {
        PayrollDatabase.addUnionMember(memberId, employee);
    }

    @Override
    protected Affiliation getAffiliation() {
        return new UnionAffiliation(memberId, charge);
    }
}
