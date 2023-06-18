package com.payroll.transactionFactory;

import com.payroll.transactionImpl.*;

import java.util.Date;

/**
 * P253 ~ P254 图22.8 Transaction 对象工厂
 * transactionFactory 包中包含着抽象基类，这些抽象基类定义了用来描绘具体操作对象构造器的纯虚
 * 函数。transactionFactoryImpl 包中包含着 TransactionFactory 类的具体派生类，并且使用了
 * 所有要创建的具体操作对象。
 */
public interface TransactionFactory {

    AddSalariedEmployee makeAddSalaryTransaction(int empId, String empName, String empAddress, double salary);
    AddHourlyEmployee makeAddHourlyEmployee(int empId, String empName, String empAddress, double hourlyRate);
    AddCommissionedEmployee makeAddCommissionedEmployee(int empId, String empName, String empAddress, double salary, double commissionRate);
    DeleteEmployeeTransaction makeDeleteEmployeeTransaction(int empId);
    PaydayTransaction makePaydayTransaction(Date date);
    TimeCardTransaction makeTimeCardTransaction(Date date, double hours, int empId);
    SalesReceiptTransaction makeSalesReceiptTransaction(Date date, double amount, int empId);
    ChangeAddressTransaction makeChangeAddressTransaction(int empId, String newAddress);
    ChangeCommissionedTransaction makeChangeCommissionedTransaction(int empId, double salary, double commissionRate);
    ChangeDirectTransaction makeChangeDirectTransaction(int empId);
    ChangeHoldTransaction makeChangeHoldTransaction(int empId);
    ChangeHourlyTransaction makeChangeHourlyTransaction(int empId, double hourlyRate);
    ChangeMailTransaction makeChangeMailTransaction(int empId);
    ChangeMemberTransaction makeChangeMemberTransaction(int empId, int memberId, double charge);
    ChangeNameTransaction makeChangeNameTransaction(int empId, String newName);
    ChangeSalariedTransaction makeChangeSalariedTransaction(int empId, double salary);
    ChangeUnaffiliatedTransaction makeChangeUnaffiliatedTransaction(int empId);
    ServiceChargeTransaction makeServiceChargeTransaction(int memberId, Date date, double charge);

}
