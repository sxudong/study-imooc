package chapter15.v7;

import junit.framework.Assert;

/**
 * 改进 代码清单 15-2  p244
 * 两个字符串是在 if 语句体中被压缩的。我们应当拆分出一个名为 compactedExpectedAndActual 的方法。
 * 然而，我们希望 formatCompactedComparison 函数完成所有的格式化工作。而 compact...函数除了压缩
 * 之外什么都不做[G30]函数只该做一件事。所以，做如下拆分：
 */
public class ComparisonCompactor {

    private static final String ELLIPSIS = "…";
    private static final String DELTA_END = "]";
    private static final String DELTA_START = "[";

    private int contextLength;
    private String expected;
    private String actual;
    private int prefix;
    private int suffix;

    // ########### add ###########
    private String compactExpected;
    private String compactActual;
    // ###########################

    public ComparisonCompactor(int contextLength, String expected, String actual) {
        this.contextLength = contextLength;
        this.expected = expected;
        this.actual = actual;
    }

    public String formatCompactedComparison(String message) {
        if(canBeCompacted()) {
            compactExpectedAndActual();
            return Assert.format(message, compactExpected, compactActual);
        } else {
            //return Assert.format(message, expected, actual);
            return Assert.format(message, compactExpected, compactActual);
        }
    }

    // ########### add ###########
    private void compactExpectedAndActual() {
        findCommonPrefix();
        findCommonSuffix();
        compactExpected = compactString(expected);
        compactActual = compactString(actual);
    }
    // ###########################

    // 期望值和实际值不等于空，需要压缩组装
    private boolean canBeCompacted() {
        return expected != null && actual != null && !areStringsEqual();
    }

    // 压缩组装结果
    private String compactString(String source) {
        String result = DELTA_START + source.substring(prefix, source.length() - suffix + 1) + DELTA_END;
        if (prefix > 0)
            result = computeCommonPrefix() + result;
        if (suffix > 0)
            result = result + computeCommonSuffix();
        return result;
    }

    // 查找前缀
    private void findCommonPrefix() {
        suffix = 0; // 这个值没有参与运算
        int end = Math.min(expected.length(), actual.length());
        for (; prefix < end; prefix++) { // 参与运算的是prefix
            if (expected.charAt(prefix) != actual.charAt(prefix)) {
                break;
            }
        }
    }

    // 查找后缀
    private void findCommonSuffix() {
        int expectedSuffix = expected.length() - 1;
        int actualSuffix = actual.length() - 1;
        for (;actualSuffix >= prefix && expectedSuffix >= prefix;
             actualSuffix--, expectedSuffix--) {
            if (expected.charAt(expectedSuffix) != actual.charAt(actualSuffix))
                break;
        }
        suffix = expected.length() - expectedSuffix;
    }

    // 计算前缀
    private String computeCommonPrefix() {
        return (prefix > contextLength ? ELLIPSIS : "") +
                expected.substring(Math.max(0, prefix - contextLength), prefix);
    }

    // 计算后缀
    private String computeCommonSuffix() {
        int end = Math.min(expected.length() - suffix + 1 + contextLength,
                expected.length());
        return expected.substring(expected.length() - suffix + 1, end) +
                (expected.length() - suffix + 1 < expected.length() - contextLength ? ELLIPSIS : "");
    }

    private boolean areStringsEqual() {
        return expected.equals(actual);
    }
}