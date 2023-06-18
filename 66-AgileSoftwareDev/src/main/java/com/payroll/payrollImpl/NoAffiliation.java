package com.payroll.payrollImpl;

import com.payroll.payrollDomain.Affiliation;
import com.payroll.util.Paycheck;

public class NoAffiliation implements Affiliation {

    @Override
    public double calculateDeductions(Paycheck pc) {
        return 0;
    }

}
