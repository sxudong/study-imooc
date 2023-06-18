package com.payroll.payrollApplication;

import com.payroll.abstractTransaction.AddEmployeeTransaction;
import com.payroll.payrollDatabase.PayrollDatabase;
import com.payroll.payrollDatabaseImpl.PayrollDatabaseImpl;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollFactory.PayrollFactory;
import com.payroll.payrollImpl.PayrollFactoryImpl;
import com.payroll.transactionApplication.TransactionApplication;
import com.payroll.transactionFactory.TransactionFactory;
import com.payroll.transactionImpl.*;
import com.payroll.util.Paycheck;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * 支付程序入口
 *
 * https://github.com/yupengj/payment-salary/tree/master
 */
public class PayrollApplication extends TransactionApplication {

    private static PayrollDatabase payrollDatabase = new PayrollDatabase();
    private static TransactionFactory transactionFactory = TransactionFactoryImpl.getInstance();
    private static PayrollFactory payrollFactory = new PayrollFactoryImpl();

    public static void main(String[] args) {
        Date payDate = new Date("2018/6/22"); // 星期五

        // TransactionSource 来自数据库
        // TransactionSource textParserTransactionSource = getTextParserTransactionSource();
        List<Employee> emps = createEmployee();

        // PayrollApplication 自在一个循环中，交替的从 TransactionSource 获取操作，然后执行这些操作对象。
//        for (Employee emp : emps) {
//            if (emp.isPayDate(payDate)) { // 今天是不是发薪日
//                Date startDate = emp.getPayPeriodStartDate(payDate); // 计薪开始日期
//                Paycheck pc = new Paycheck(startDate, payDate);
//                emp.payDay(pc); // 支付薪水
//                payrollDatabase.savePaycheck(pc);
//            }
//        }
//        printPaycheck(emps);

        //PaydayTransaction pt = new PaydayTransaction(payDate);
        PaydayTransaction pt = transactionFactory.makePaydayTransaction(payDate);
        pt.execute();// 支付薪水
        printPaycheck2(emps, pt);
    }

    protected static void printPaycheck(List<Employee> emps) {
        for (Employee emp : emps) {
            System.out.println();
            System.out.println(emp);
            List<Paycheck> paychecks = payrollDatabase.findPaychecks(emp.getItsEmpId());
            if (paychecks != null) {
                paychecks.forEach(it -> System.out.println(it.getItsEmpId()));
            }
        }
    }

    protected static void printPaycheck2(List<Employee> emps, PaydayTransaction pt) {
        for (Employee emp : emps) {
            System.out.println();
            System.out.println(emp);
            Paycheck paycheck = pt.getPaycheck(emp.getItsEmpId());
            Optional.ofNullable(paycheck).ifPresent(p -> System.out.println(p.getItsEmpId()));
        }
    }

    public static List<Employee> createEmployee() {
        // 员工1：增加小时工
        Integer empId1 = 1;
        AddEmployeeTransaction addEmp = transactionFactory.makeAddHourlyEmployee(empId1, "张三", "上海", 10);
        addEmp.execute();

        // 给小时工增加工时卡
        TimeCardTransaction timeCardTransaction = transactionFactory.makeTimeCardTransaction(new Date("2018/6/18"), 100, empId1);
        timeCardTransaction.execute();

        // 给小时工增加会费
        Integer memberId1 = 1;
        ChangeMemberTransaction memberTransaction = transactionFactory.makeChangeMemberTransaction(empId1, memberId1, 10); // 转变成一个协会成员
        memberTransaction.execute();
        ServiceChargeTransaction serviceChangeTransaction = transactionFactory.makeServiceChargeTransaction(memberId1, new Date("2018/6/18"), 20); // 服务费
        serviceChangeTransaction.execute();

        // 员工2：增加销售雇员
        Integer empId2 = 2;
        addEmp = new AddCommissionedEmployee(empId2, "李四", "上海", 1000, 0.5);
        addEmp.execute();

        // 增加销售凭条
        SalesReceiptTransaction salesReceiptTransaction1 = transactionFactory.makeSalesReceiptTransaction(new Date("2018/6/18"), 100, empId2);
        salesReceiptTransaction1.execute();
        // 增加销售凭条
        SalesReceiptTransaction salesReceiptTransaction2 = transactionFactory.makeSalesReceiptTransaction(new Date("2018/6/18"), 50, empId2);
        salesReceiptTransaction2.execute();

        // 员工1：增加固定工资员工
        Integer empId3 = 3;
        addEmp = transactionFactory.makeAddSalaryTransaction(empId3, "王五", "上海", 1000);
        addEmp.execute();

        return new ArrayList<>(payrollDatabase.getAllEmployee());
    }
}