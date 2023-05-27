package com.payroll.transaction;

import com.payroll.affiliation.Affiliation;
import com.payroll.affiliation.NoAffiliation;
import com.payroll.affiliation.UnionAffiliation;
import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;

public class ChangeUnaffiliatedTransaction extends ChangeAffiliationTransaction{

    public ChangeUnaffiliatedTransaction(int empId) {
        super(empId);
    }

    @Override
    protected void recordMembership(Employee employee) {
        Affiliation uf = employee.getAffiliation();
        if(uf instanceof UnionAffiliation){
            int memberId = ((UnionAffiliation)uf).getMemberId();
            PayrollDatabase.deleteUnionMember(memberId);
        }
    }

    @Override
    protected Affiliation getAffiliation() {
        return new NoAffiliation();
    }
}
