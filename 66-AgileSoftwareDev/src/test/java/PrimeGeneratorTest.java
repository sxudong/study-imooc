import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class PrimeGeneratorTest  {

    @Test
    public void testPrimes() {
        int[] nullArray = PrimeGenerator.generatePrimes(0);
        assertEquals(0, nullArray.length);

        int[] minArray = PrimeGenerator.generatePrimes(2);
        assertEquals(1, minArray.length);
        assertEquals(2, minArray[0]);

        int[] threeArray = PrimeGenerator.generatePrimes(3);
        assertEquals(2, threeArray.length);
        assertEquals(2, threeArray[0]);
        assertEquals(3, threeArray[1]);

        int[] fourArray = PrimeGenerator.generatePrimes(100);
        assertEquals(25, fourArray.length);
        assertEquals(97, fourArray[24]);
    }

    @Test
    public void testExhaustive() {
        for (int i = 2; i <= 500; i++) {
            verifyPrimeList(PrimeGenerator.generatePrimes(i));
        }
    }

    private void verifyPrimeList(int[] list) {
        for (int i = 0; i < list.length; i++) {
            verifyPrime(list[i]);
        }
    }

    private void verifyPrime(int n) {
        for (int factor = 2; factor < n; factor++) {
            assert (n%factor != 0);
        }
    }
}
