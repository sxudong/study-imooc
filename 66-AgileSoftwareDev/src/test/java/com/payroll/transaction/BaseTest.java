package com.payroll.transaction;

import com.payroll.payrollDatabase.PayrollDatabase;
import org.junit.After;

/**
 * 防止测试用例之间互相干扰，每个测试用例结束时清空测试数据
 */
public class BaseTest {

    private static int count = 1;

    @After
    public void after() {
        PayrollDatabase.clearAll();
        System.out.printf("当前测试用例个数：%s\n", count++);
    }
}
