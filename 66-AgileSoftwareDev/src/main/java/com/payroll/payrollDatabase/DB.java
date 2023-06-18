package com.payroll.payrollDatabase;

import com.payroll.payrollDomain.Affiliation;
import com.payroll.payrollDomain.Employee;
import com.payroll.payrollImpl.SalesReceipt;
import com.payroll.payrollImpl.TimeCard;
import com.payroll.util.Paycheck;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 模拟数据库的类
 * https://github.com/yupengj/payment-salary/tree/master
 */
public class DB {

//    public Map<String, Employee> employees = new HashMap<String, Employee>(); // 雇员
//    private Map<Integer, Employee> empUnions = new HashMap<>(); // 协会会员 ID -- 雇员
    public Map<Integer, Employee> employees = new HashMap<>();
    public Map<Integer, Employee> empUnions = new HashMap<>();
    public Map<String, Affiliation> memberId2Affiliation = new HashMap<String, Affiliation>();
    public Map<String, List<Employee>> memberId2Emps = new HashMap<String, List<Employee>>();
    public Map<String, List<TimeCard>> empId2TimeCards = new HashMap<String, List<TimeCard>>();
    public Map<String, List<SalesReceipt>> empId2SalesReceipts = new HashMap<String, List<SalesReceipt>>();
    //public Map<String, List<Paycheck>> empId2Paycheck = new HashMap<String, List<Paycheck>>();
    //public Map<String, List<ServiceChange>> memberId2Sc = new HashMap<String, List<ServiceChange>>();
    public Map<Integer, List<Paycheck>> empId2Paycheck = new HashMap<Integer, List<Paycheck>>();

    private static DB db = new DB();

    private DB() {
    }

    public static DB getInstance() {
        return db;
    }
}
