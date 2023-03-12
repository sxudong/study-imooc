package com.example.test;
 
import org.junit.jupiter.api.Test;
 
import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * jacoco 代码覆盖率
 * https://blog.csdn.net/qq_39208536/article/details/125653263
 */
public class CalculatorTest {
    @Test
    public void testCalculator1() {
        Calculator calculator = new Calculator();
        assertEquals(10,calculator.add(6,4));
    }
 
    @Test
    public void testCalculator2() {
        Calculator calculator = new Calculator();
        assertEquals(1,calculator.subtraction(10,9));
    }
}