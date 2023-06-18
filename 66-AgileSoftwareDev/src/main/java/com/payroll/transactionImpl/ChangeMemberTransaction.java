package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeAffiliationTransaction;
import com.payroll.payrollDomain.Affiliation;
import com.payroll.payrollImpl.UnionAffiliation;
import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;

/**
 * 程序19.34 P206
 */
public class ChangeMemberTransaction extends ChangeAffiliationTransaction {

    private int memberId;
    private double charge;

    public ChangeMemberTransaction(int empId, int memberId, double charge) {
        super(empId);
        this.memberId = memberId;
        this.charge = charge;
    }

    // P205 记录成员关系，把 memberId 和 Employee 实例绑定起来
    // 在 ChangeUnaffiliatedTransaction 中该函数清除掉成员关系记录。
    @Override
    protected void recordMembership(Employee employee) {
        PayrollDatabase.addUnionMember(memberId, employee);
    }

    @Override
    protected Affiliation getAffiliation() {
        return new UnionAffiliation(memberId, charge);
    }
}
