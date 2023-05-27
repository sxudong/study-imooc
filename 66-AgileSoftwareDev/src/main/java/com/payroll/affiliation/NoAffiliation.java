package com.payroll.affiliation;

import com.payroll.util.Paycheck;

public class NoAffiliation implements Affiliation{

    @Override
    public double calculateDeductions(Paycheck pc) {
        return 0;
    }

}
