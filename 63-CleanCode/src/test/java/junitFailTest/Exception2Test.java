package junitFailTest;

import org.junit.Test;

import java.util.ArrayList;

import static junit.framework.TestCase.fail;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.Assert.assertEquals;


/**
 * fail() 尝试捕获并始终失败
 * 如果您要测试的行没有引发任何异常，而您忘记放置fail() ，则测试将通过（假肯定）。
 */
public class Exception2Test {

    @Test
    public void testFail1() {
        Calculator calculator = new Calculator();
        try {
            int result = calculator.divide(12, 0);
            fail("没有抛出异常，测试失败"); // 如果执行到这行代码，则证明没有抛出异常，说明我们的验证失败
        } catch (Exception e) {
        }
    }

    @Test
    public void testFail2() {
        Calculator calculator = new Calculator();
        try {
            int result = calculator.divide(12, 2);
            fail("没有抛出异常，测试失败"); // 如果执行到这行代码，则证明没有抛出异常，说明我们的验证失败
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testFail3() {
        Throwable tx = null;
        Calculator calculator = new Calculator();
        try {
            int result = calculator.divide(12, 0);
        } catch (Exception e) {
            e.printStackTrace();
            tx = e;
        }

        // 判断方法的返回结果
        assertEquals(Exception.class, tx.getClass()); // 抛出的异常类型是否和期望一致
        assertEquals("除数不能为0", tx.getMessage()); // 抛出的异常信息是否和期望一致
    }

    @Test
    public void testDivisionWithException() {
        try {
            //int i = 1 / 0;
            fail(); //remember this line, else 'may' false positive
        } catch (ArithmeticException e) {
            assertThat(e.getMessage(), is("/ by zero"));
			//assert others
        }
    }
 
    @Test
    public void testEmptyList() {
        try {
            new ArrayList<>().get(0);
            fail();
        } catch (IndexOutOfBoundsException e) {
            assertThat(e.getMessage(), is("Index: 0, Size: 0"));
        }
    }

    class Calculator {
        public int divide(int a, int b) throws Exception {
            if(0 == b) {
                throw new Exception("除数不能为0");
            }
            return a / b;
        }
    }
}

