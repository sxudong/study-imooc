package com.payroll.payrollDatabase;

import com.payroll.payrollDomain.Employee;

import java.util.Collection;

/**
 * 模拟与数据库交互接口
 */
public interface Database {
    void addEmployee(Employee employee);
    Employee getEmployee(Integer empId);
    Employee deleteEmploy(int empId);
    void addUnionMember(int memberId, Employee employee);
    Employee getUnionMember(Integer memberId);
    Employee deleteUnionMember(int memberId);
    Collection<Employee> getAllEmployee();
    Collection<Employee> getAllUnionMember();
    void clearAll();
    void createEmployee();
}
