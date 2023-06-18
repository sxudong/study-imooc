package com.payroll.transactionImpl;

import com.payroll.abstractTransaction.ChangeAffiliationTransaction;
import com.payroll.payrollDomain.Affiliation;
import com.payroll.payrollImpl.PayrollFactoryImpl;
import com.payroll.payrollImpl.UnionAffiliation;
import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;

/**
 * 程序19.34 P207
 */
public class ChangeUnaffiliatedTransaction extends ChangeAffiliationTransaction {

    public ChangeUnaffiliatedTransaction(int empId) {
        super(empId);
    }

    // P205 在 ChangeMethodTransaction 中记录成员关系。
    // 在 ChangeUnaffiliatedTransaction 清除掉成员关系记录。
    @Override
    protected void recordMembership(Employee employee) {
        Affiliation uf = employee.getAffiliation();
        // 必须要确定当前雇员是否为一个协会成员，那么它就从 UnionAffiliation
        // 中获取 memberId 并清除成员关系记录。
        if(uf instanceof UnionAffiliation){
            int memberId = ((UnionAffiliation)uf).getMemberId();
            PayrollDatabase.deleteUnionMember(memberId);
        }
    }

    @Override
    protected Affiliation getAffiliation() {
        //return new NoAffiliation();
        return PayrollFactoryImpl.getInstance().makeNoAffiliation();
    }
}
