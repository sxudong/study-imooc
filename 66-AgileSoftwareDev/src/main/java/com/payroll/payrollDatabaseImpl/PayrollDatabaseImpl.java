package com.payroll.payrollDatabaseImpl;

import com.payroll.abstractTransaction.AddEmployeeTransaction;
import com.payroll.payrollDatabase.DB;
import com.payroll.payrollDatabase.Database;
import com.payroll.payrollDomain.Employee;
import com.payroll.transactionImpl.*;
import com.payroll.util.Paycheck;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

public class PayrollDatabaseImpl implements Database {
    private DB db = DB.getInstance();

//    /** 雇员 */
//    private static Map<Integer, Employee> employees = new HashMap<>();
//    /** 协会会员 ID -- 雇员 */
//    private static Map<Integer, Employee> empUnions = new HashMap<>();

    @Override
    public void addEmployee(Employee employee) {
        db.employees.put(employee.getItsEmpId(), employee);
    }

    @Override
    public Employee getEmployee(Integer empId) {
        return db.employees.get(empId);
    }

    @Override
    public Employee deleteEmploy(int empId) {
        Employee employee = db.employees.get(empId);
        db.employees.remove(empId);
        return employee;
    }

    @Override
    public void addUnionMember(int memberId, Employee employee) {
        db.empUnions.put(memberId, employee);
    }

    @Override
    public Employee getUnionMember(Integer memberId) {
        return db.empUnions.get(memberId);
    }

    @Override
    public Employee deleteUnionMember(int memberId) {
        Employee employee = db.empUnions.get(memberId);
        db.empUnions.remove(memberId);
        return employee;
    }

    @Override
    public Collection<Employee> getAllEmployee() {
        return db.employees.values();
    }

    @Override
    public Collection<Employee> getAllUnionMember() {
        return db.empUnions.values();
    }

    public void savePaycheck(Paycheck paycheck) {
        if (!db.empId2Paycheck.containsKey(paycheck.getItsEmpId())) {
            db.empId2Paycheck.put(paycheck.getItsEmpId(), new ArrayList<>());
        }
        db.empId2Paycheck.get(paycheck.getItsEmpId()).add(paycheck);
    }

    public List<Paycheck> getPaycheckByEmpId(int itsEmpId) {
        return db.empId2Paycheck.get(itsEmpId);
    }

    @Override
    public void clearAll() {
        db.employees.clear();
        db.empUnions.clear();
    }

    @Override
    public void createEmployee() {
        // 员工1：增加小时工
        Integer empId1 = 1;
        AddEmployeeTransaction addEmp = new AddHourlyEmployee(empId1, "张三", "上海", 10);
        addEmp.execute();

        // 给小时工增加工时卡
        TimeCardTransaction timeCardTransaction = new TimeCardTransaction(new Date("2018/6/18"), 100, empId1);
        timeCardTransaction.execute();

        // 给小时工增加会费
        Integer memberId1 = 1;
        ChangeMemberTransaction memberTransaction = new ChangeMemberTransaction(empId1, memberId1, 10); // 转变成一个协会成员
        memberTransaction.execute();
        ServiceChargeTransaction serviceChangeTransaction = new ServiceChargeTransaction(memberId1, new Date("2018/6/18"), 20); // 服务费
        serviceChangeTransaction.execute();

        // 员工2：增加销售雇员
        Integer empId2 = 2;
        addEmp = new AddCommissionedEmployee(empId2, "李四", "上海", 1000, 0.5);
        addEmp.execute();

        // 增加销售凭条
        SalesReceiptTransaction salesReceiptTransaction1 = new SalesReceiptTransaction(new Date("2018/6/18"), 100, empId2);
        salesReceiptTransaction1.execute();
        // 增加销售凭条
        SalesReceiptTransaction salesReceiptTransaction2 = new SalesReceiptTransaction(new Date("2018/6/18"), 50, empId2);
        salesReceiptTransaction2.execute();

        // 员工1：增加固定工资员工
        Integer empId3 = 3;
        addEmp = new AddSalariedEmployee(empId3, "王五", "上海", 1000);
        addEmp.execute();
    }
}
