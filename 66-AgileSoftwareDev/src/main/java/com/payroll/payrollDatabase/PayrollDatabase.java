package com.payroll.payrollDatabase;

import com.payroll.payrollDatabaseImpl.PayrollDatabaseImpl;
import com.payroll.payrollImpl.PayrollFactoryImpl;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollFactory.PayrollFactory;
import com.payroll.util.Paycheck;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class PayrollDatabase {
    private static PayrollDatabaseImpl payrollDatabase = new PayrollDatabaseImpl();

    public static void addEmployee(Employee employee) {
        payrollDatabase.addEmployee(employee);
    }

    public static Employee getEmployee(Integer empId) {
        return payrollDatabase.getEmployee(empId);
    }

    public static Employee deleteEmploy(int empId) {
        return payrollDatabase.deleteEmploy(empId);
    }

    public static void addUnionMember(int memberId, Employee employee) {
        payrollDatabase.addUnionMember(memberId, employee);
    }

    public static Employee getUnionMember(Integer memberId) {
        return payrollDatabase.getUnionMember(memberId);
    }

    public static Employee deleteUnionMember(int memberId) {
        return payrollDatabase.deleteUnionMember(memberId);
    }

    public static Collection<Employee> getAllEmployee(){
        return payrollDatabase.getAllEmployee();
    }

    public static Collection<Employee> getAllUnionMember(){
        return payrollDatabase.getAllUnionMember();
    }

    public static void savePaycheck(Paycheck pc) {
        payrollDatabase.savePaycheck(pc);
    }

    public static void clearAll() {
        payrollDatabase.clearAll();
    }

    /**
     * 模拟从数据库查询员工数据，然后构建成内存对象
     */
    public List<Employee> findAllEmpByInit() {
        payrollDatabase.createEmployee();
        return findAllEmp();
    }

    /**
     * 直接查询内存中的员工对象
     */
    public List<Employee> findAllEmp() {
        return new ArrayList<>(payrollDatabase.getAllEmployee());
    }

    public List<Paycheck> findPaychecks(int itsEmpId) {
        return payrollDatabase.getPaycheckByEmpId(itsEmpId);
    }
}
