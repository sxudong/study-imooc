package com.payroll.transactionImpl;

import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionApplication.Transaction;
import com.payroll.util.Paycheck;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 程序19.37  P211
 */
public class PaydayTransaction implements Transaction {

    private Date date;
    private Map<Integer, Paycheck> paycheckMap = new HashMap<>();

    public PaydayTransaction(Date date) {
        this.date = date;
    }

    // 程序19.48 P216
    @Override
    public void execute() {
        for (Employee employee : PayrollDatabase.getAllEmployee()) {
            if (employee.isPayDate(date)) { // 今天是不是发薪日
                Date startDate = employee.getPayPeriodStartDate(date); // 计薪开始日期
                Paycheck paycheck = new Paycheck(startDate, date);
                paycheckMap.put(employee.getItsEmpId(), paycheck);
                employee.payDay(paycheck);
            }
        }
    }

    public Paycheck getPaycheck(int employeeId) {
        return paycheckMap.get(employeeId);
    }
}
