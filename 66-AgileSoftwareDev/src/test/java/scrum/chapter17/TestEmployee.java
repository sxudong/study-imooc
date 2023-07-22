package scrum.chapter17;

import junit.framework.TestCase;

import java.util.Date;

/**
 * 《敏捷软件开发》第17章 NULL OBJECT 模式 P171
 */
public class TestEmployee extends TestCase {
    public void testNull() {
        Employee employee = DB.getEmployee("Bob");
        if (employee.isTimeToPay(new Date())) {
            fail();
        }
        assertEquals(Employee.NULL, employee);
    }
}
