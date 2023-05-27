package com.payroll.transaction;

import com.payroll.affiliation.Affiliation;
import com.payroll.affiliation.UnionAffiliation;
import com.payroll.database.PayrollDatabase;
import com.payroll.emp.Employee;
import lombok.AllArgsConstructor;

import java.util.Date;

@AllArgsConstructor
public class ServiceChargeTransaction implements Transaction{

    private int memberId;

    private Date date;

    private double charge;

    @Override
    public void execute() {
        Employee employee = PayrollDatabase.getUnionMember(memberId);
        Affiliation af = employee.getAffiliation();
        if(af instanceof UnionAffiliation){
            ((UnionAffiliation)af).addServiceCharge(date, charge);
        }
    }
}
