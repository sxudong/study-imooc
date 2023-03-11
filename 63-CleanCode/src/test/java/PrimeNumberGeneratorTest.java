import chapter4.PrimeNumberGenerator;
import org.junit.Test;

import java.util.Arrays;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

/**
 * Junit测试用例来测试我们的 Eratosthenes Sieve 算法
 * 用于生成一个给定整数的素数
 */
public class PrimeNumberGeneratorTest {
    public PrimeNumberGeneratorTest() {
        System.out.println("Generator prime numbers using Sieve of Eratosthenes algorithm");
    }

    @Test
    public void testPrimes() {
        // 0和1不被认为是素数
        int[] primeUptoZero = PrimeNumberGenerator.generatePrimeNumbersUpto(0);
        assertEquals(0, primeUptoZero.length);

        int[] primeUptoTwo = PrimeNumberGenerator.generatePrimeNumbersUpto(2);
        Arrays.stream(primeUptoTwo).forEach(i -> System.out.println(i)); // 2
        assertEquals(1, primeUptoTwo.length);
        assertEquals(2, primeUptoTwo[0]);

        int[] primeUptoThree = PrimeNumberGenerator.generatePrimeNumbersUpto(3);
        assertEquals(2, primeUptoThree.length);
        assertEquals(2, primeUptoThree[0]);
        assertEquals(3, primeUptoThree[1]);

        int[] primeUptoHundred = PrimeNumberGenerator.generatePrimeNumbersUpto(100);
        assertEquals(25, primeUptoHundred.length);
        assertEquals(97, primeUptoHundred[24]);
    }

    @Test
    public void testExhaustive() {
        for (int i = 2; i < 700; i++) {
            verifyPrimeList(PrimeNumberGenerator.generatePrimeNumbersUpto(i));
        }
    }

    private void verifyPrimeList(int[] listOfPrimes) {
        for (int i = 0; i < listOfPrimes.length; i++) {
            verifyPrime(listOfPrimes[i]);
        }
    }

    private void verifyPrime(int number) {
        for (int factor = 2; factor < number; factor++) {
            assertTrue(number % factor != 0);
        }
    }
}