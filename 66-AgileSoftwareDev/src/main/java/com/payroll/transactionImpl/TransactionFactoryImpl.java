package com.payroll.transactionImpl;

import com.payroll.transactionFactory.TransactionFactory;

import java.util.Date;

/**
 * P253 ~ P254 图22.8 Transaction 对象工厂
 */
public class TransactionFactoryImpl implements TransactionFactory {
    private static TransactionFactoryImpl instance = new TransactionFactoryImpl();

    private TransactionFactoryImpl() {
    }

    public static TransactionFactoryImpl getInstance() {
        return instance;
    }

    @Override
    public AddSalariedEmployee makeAddSalaryTransaction(int empId, String empName, String empAddress, double salary) {
        return new AddSalariedEmployee(empId, empName, empAddress, salary);
    }

    @Override
    public AddHourlyEmployee makeAddHourlyEmployee(int empId, String empName, String empAddress, double hourlyRate) {
        return new AddHourlyEmployee(empId, empName, empAddress, hourlyRate);
    }

    @Override
    public AddCommissionedEmployee makeAddCommissionedEmployee(int empId, String empName, String empAddress, double salary, double commissionRate) {
        return new AddCommissionedEmployee(empId, empName, empAddress, salary, commissionRate);
    }

    @Override
    public DeleteEmployeeTransaction makeDeleteEmployeeTransaction(int empId) {
        return new DeleteEmployeeTransaction(empId);
    }

    @Override
    public PaydayTransaction makePaydayTransaction(Date date) {
        return new PaydayTransaction(date);
    }

    @Override
    public TimeCardTransaction makeTimeCardTransaction(Date date, double hours, int empId) {
        return new TimeCardTransaction(date, hours, empId);
    }

    @Override
    public SalesReceiptTransaction makeSalesReceiptTransaction(Date date, double amount, int empId) {
        return new SalesReceiptTransaction(date, amount, empId);
    }

    @Override
    public ChangeAddressTransaction makeChangeAddressTransaction(int empId, String newAddress) {
        return new ChangeAddressTransaction(empId, newAddress);
    }

    @Override
    public ChangeCommissionedTransaction makeChangeCommissionedTransaction(int empId, double salary, double commissionRate) {
        return new ChangeCommissionedTransaction(empId, salary, commissionRate);
    }

    @Override
    public ChangeDirectTransaction makeChangeDirectTransaction(int empId) {
        return new ChangeDirectTransaction(empId);
    }

    @Override
    public ChangeHoldTransaction makeChangeHoldTransaction(int empId) {
        return new ChangeHoldTransaction(empId);
    }

    @Override
    public ChangeHourlyTransaction makeChangeHourlyTransaction(int empId, double hourlyRate) {
        return new ChangeHourlyTransaction(empId, hourlyRate);
    }

    @Override
    public ChangeMailTransaction makeChangeMailTransaction(int empId) {
        return new ChangeMailTransaction(empId);
    }

    @Override
    public ChangeMemberTransaction makeChangeMemberTransaction(int empId, int memberId, double charge) {
        return new ChangeMemberTransaction(empId, memberId, charge);
    }

    @Override
    public ChangeNameTransaction makeChangeNameTransaction(int empId, String newName) {
        return new ChangeNameTransaction(empId, newName);
    }

    @Override
    public ChangeSalariedTransaction makeChangeSalariedTransaction(int empId, double salary) {
        return new ChangeSalariedTransaction(empId, salary);
    }

    @Override
    public ChangeUnaffiliatedTransaction makeChangeUnaffiliatedTransaction(int empId) {
        return new ChangeUnaffiliatedTransaction(empId);
    }

    @Override
    public ServiceChargeTransaction makeServiceChargeTransaction(int memberId, Date date, double charge) {
        return new ServiceChargeTransaction(memberId, date, charge);
    }
}
