package com.payroll.payrollFactory;

import com.payroll.payrollImpl.*;

import java.util.Date;

/**
 * 图22.10 新增的 PayrollFactory，书中没有说这个类具体用来做什么。P254
 */
public interface PayrollFactory {

	BiweeklySchedule makeBiweeklySchedule();
	CommissionedClassification makeCommissionedClassification(Double salary, Double commissionRate);
	DirectMethod makeDirectMethod();
	HoldMethod makeHoldMethod();
	HourlyClassification makeHourlyClassification(Double hourlyRate);
	MailMethod makeMailMethod();
	MonthlySchedule makeMonthlySchedule();
	NoAffiliation makeNoAffiliation();
	SalariedClassification makeSalariedClassification(Double salary);
	SalesReceipt makeSalesReceipt(Date date, Double amount);
	ServiceCharge makeServiceCharge(Date date, Double amount);
	TimeCard makeTimeCard(Date date, Double hours);
	UnionAffiliation makeUnionAffiliation(Integer memberId, Double charge);
	WeeklySchedule makeWeeklySchedule();
}