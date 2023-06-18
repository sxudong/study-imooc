package com.payroll.transactionImpl;

import com.payroll.payrollDomain.Affiliation;
import com.payroll.payrollImpl.UnionAffiliation;
import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionApplication.Transaction;

import java.util.Date;

/**
 * 程序19.17 服务费 P195
 */
public class ServiceChargeTransaction implements Transaction {

    private int memberId;
    private Date date;
    private double charge;

    public ServiceChargeTransaction(int memberId, Date date, double charge) {
        this.memberId = memberId;
        this.date = date;
        this.charge = charge;
    }

    @Override
    public void execute() {
        Employee employee = PayrollDatabase.getUnionMember(memberId);
        Affiliation af = employee.getAffiliation(); // 协会对象
        if(af instanceof UnionAffiliation){
            ((UnionAffiliation) af).addServiceCharge(date, charge);
        }
    }
}
