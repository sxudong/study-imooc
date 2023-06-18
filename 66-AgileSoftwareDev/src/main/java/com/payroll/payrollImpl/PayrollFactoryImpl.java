package com.payroll.payrollImpl;

import com.payroll.payrollFactory.PayrollFactory;

import java.util.Date;

/**
 * 图22.10 新增的 PayrollFactory，书中没有说这个类具体用来做什么。P254
 */
public class PayrollFactoryImpl implements PayrollFactory {

	@Override
	public BiweeklySchedule makeBiweeklySchedule() {
		return new BiweeklySchedule();
	}

	@Override
	public CommissionedClassification makeCommissionedClassification(Double salary, Double commissionRate) {
		return new CommissionedClassification(salary, commissionRate);
	}

	@Override
	public DirectMethod makeDirectMethod() {
		return new DirectMethod();
	}

	@Override
	public HoldMethod makeHoldMethod() {
		return new HoldMethod();
	}

	@Override
	public HourlyClassification makeHourlyClassification(Double hourlyRate) {
		return new HourlyClassification(hourlyRate);
	}

	@Override
	public MailMethod makeMailMethod() {
		return new MailMethod();
	}

	@Override
	public MonthlySchedule makeMonthlySchedule() {
		return new MonthlySchedule();
	}

	@Override
	public NoAffiliation makeNoAffiliation() {
		return new NoAffiliation();
	}

	@Override
	public SalariedClassification makeSalariedClassification(Double salary) {
		return new SalariedClassification(salary);
	}

	@Override
	public SalesReceipt makeSalesReceipt(Date date, Double amount) {
		return new SalesReceipt(date, amount);
	}

	@Override
	public ServiceCharge makeServiceCharge(Date date, Double amount) {
		return new ServiceCharge(date, amount);
	}

	@Override
	public TimeCard makeTimeCard(Date date, Double hours) {
		return new TimeCard(date, hours);
	}

	@Override
	public UnionAffiliation makeUnionAffiliation(Integer memberId, Double charge) {
		return new UnionAffiliation(memberId, charge);
	}

	@Override
	public WeeklySchedule makeWeeklySchedule() {
		return new WeeklySchedule();
	}

}