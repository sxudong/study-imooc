package com.demo;


/**
 * 此类使用以下内容生成达到给定限制的素数
 * Eratosthenes算法筛选。在这个算法中，我们创建了
 * 从2开始的整数数组，然后找到第一个未交叉的整数
 * 整数，并将其全部交叉。重复该过程直到阵列中没有多个倍数。
 * https://blog.csdn.net/qq_39662660/article/details/88207691
 */
public class PrimeNumberGenerator {
    private enum Marker {
        CROSSED, UNCROSSED;
    }

    private static Marker[] crossedOut;
    private static int[] primes;

    public static int[] generatePrimeNumbersUpto(int limit) {
        if (limit < 2) {
            return new int[0];

        } else {
            uncrossIntegerUpto(limit);
            crossOutMultiples();
            putUncrossedIntegersIntoPrimes();
            return primes;
        }
    }

    private static void uncrossIntegerUpto(int limit) {
        crossedOut = new Marker[limit + 1];
        for (int i = 2; i < crossedOut.length; i++) {
            crossedOut[i] = Marker.UNCROSSED;
        }
    }

    private static void crossOutMultiples() {
        int iterationLimit = determineIterationLimit();
        for (int i = 2; i <= iterationLimit; i++) {
            if (notCrossed(i)) {
                crossOutMultipleOf(i);
            }
        }
    }

    private static int determineIterationLimit() {
        //数组中的每个倍数都有一个素数因子
        //小于或等于平方根数组大小，我们不需要越过
        //大于根的倍数。
        double iterationLimit = Math.sqrt(crossedOut.length);
        return (int) iterationLimit;
    }

    private static boolean notCrossed(int i) {
        return crossedOut[i] == Marker.UNCROSSED;
    }

    private static void crossOutMultipleOf(int i) {
        for (int multiple = 2 * i;
             multiple < crossedOut.length;
             multiple += i) {
            crossedOut[multiple] = Marker.CROSSED;
        }
    }

    private static void putUncrossedIntegersIntoPrimes() {
        primes = new int[numberOfUncrossedIntegers()];
        for (int j = 0, i = 2; i < crossedOut.length; i++) {
            if (notCrossed(i)) {
                primes[j++] = i;
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