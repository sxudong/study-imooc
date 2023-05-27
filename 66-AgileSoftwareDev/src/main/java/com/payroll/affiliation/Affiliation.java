package com.payroll.affiliation;

import com.payroll.util.Paycheck;

/**
 * 协会从属关系
 */
public interface Affiliation {

    double calculateDeductions(Paycheck pc);
}
