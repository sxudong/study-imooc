/**
 * This class Generates Prime numbers up to a user specified maximum.
 * The algorithm used is the Sieve of Eratosthenes.
 * Given an array of integers starting at 2:
 * Find the first uncrossed integer, and cross out all its
 * multiples. Repeat until there are no more multiples in the array.
 * 该类用于生成不超过用户指定最大值的所有质数。
 * 所使用的算法是埃拉托斯特尼筛法。
 * 给定一个从 2 开始的整数数组：
 * 找出第一个未被筛掉的整数，然后筛掉它的所有倍数。
 * 重复此过程，直到数组中不再有倍数为止。
 *
 * <敏捷软件开发> 第5章 重构
 */
public class PrimeGenerator {
    private static boolean[] crossedOut;
    private static int[] result;

    public static int[] generatePrimes(int maxValue) {
        if (maxValue < 2) {
            return new int[0];
        } else {
            uncrossIntegersUpTo(maxValue);
            crossOutMultiples();
            putUncrossedIntegersIntoResult();
            return result;
        }
    }

    private static void uncrossIntegersUpTo(int maxValue) {
        crossedOut = new boolean[maxValue + 1];
        for (int i = 2; i < crossedOut.length; i++) {
            crossedOut[i] = false;
        }
    }

    private static void crossOutMultiples() {
        int maxPrimeFactor = determineIterationLimit();
        for (int i = 2; i <= maxPrimeFactor; i++) {
            if (notCrossed(i)) {
                crossOutMultiplesOf(i);
            }
        }
    }

    private static int determineIterationLimit() {
        // We cross out all multiples of p; where p is prime.
        // Thus, all crossed out multiples have p and q for
        // factors. If p > sqrt of the size of the array, then
        // q will never be greater than 1. Thus p is the
        // largest prime factor in the array, and is also
        // the iteration limit.
        // 我们筛掉所有 p 的倍数；其中 p 是质数。因此，所有被筛掉的倍数都有因子 p 和 q。
        // 如果 p 大于数组大小的平方根，那么 q 将永远不会大于 1。
        // 因此 p 是数组中的最大质因数，同时也是迭代的上限。
        // Every multiple in the array has a prime factor that
        // is less than or equal to the root of the array size,
        // larger than that root.
        // 每个数组中的倍数都有一个质因数，小于等于数组大小的平方根，大于该平方根。
        double iterationLimit = Math.sqrt(crossedOut.length) + 1;
        return (int) iterationLimit;
    }

    private static void crossOutMultiplesOf(int i) {
        for (int mutiple = 2 * i; mutiple < crossedOut.length; mutiple += i) {
            crossedOut[mutiple] = true;
        }
    }

    private static boolean notCrossed(int i) {
        return !crossedOut[i];
    }

    private static void putUncrossedIntegersIntoResult() {
        result = new int[numberOfUncrossedIntegers()];
        int j = 0;
        for (int i = 2; i < crossedOut.length; i++) {
            if (notCrossed(i)) {
                result[j++] = i;
            }
        }
    }

    private static int numberOfUncrossedIntegers() {
        int count = 0;
        for (int i = 2; i < crossedOut.length; i++) {
            if (notCrossed(i)) {
                count++;
            }
        }
        return count;
    }
}