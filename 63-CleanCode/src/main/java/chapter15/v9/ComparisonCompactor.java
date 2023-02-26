package chapter15.v9;

import junit.framework.Assert;

/**
 * 改进 代码清单 15-2  p246
 *
 */
public class ComparisonCompactor {

    private static final String ELLIPSIS = "…";
    private static final String DELTA_END = "]";
    private static final String DELTA_START = "[";

    private int contextLength;
    private String expected;
    private String actual;
    //private int prefix;
    private int prefixIndex;
    //private int suffix;
    private int suffixIndex;

    private String compactExpected;
    private String compactActual;

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
            return Assert.format(message, compactExpected, compactActual);
        }
    }

    /**
     * 我们恢复了 findCommonPrefix() 和 findCommonSuffix() 的原样，
     * 把 findCommonSuffix() 改名称为 findCommonPrefixAndSuffix()，
     * 让它在执行其人操作之前，先调用 findCommonPrefix()。这样一来，就以
     * 一种比前手段有效的方式建立了两个函数之间的时序关系。
     */
    private void compactExpectedAndActual() {
        //int prefixIndex = findCommonPrefix();
        //int suffixIndex = findCommonSuffix(prefixIndex);
        findCommonPrefixAndSuffix();
        compactExpected = compactString(expected);
        compactActual = compactString(actual);
    }

    // 查找前缀和后缀
    //private int findCommonSuffix(Integer prefixIndex) {
    private void findCommonPrefixAndSuffix() {
        findCommonPrefix();
        int expectedSuffix = expected.length() - 1;
        int actualSuffix = actual.length() - 1;
        for (;actualSuffix >= prefixIndex && expectedSuffix >= prefixIndex; actualSuffix--, expectedSuffix--) {
            if (expected.charAt(expectedSuffix) != actual.charAt(actualSuffix)) {
                break;
            }
        }
        // suffix = expected.length() - expectedSuffix;
        suffixIndex = expected.length() - expectedSuffix;
    }

    // 查找前缀
    //private int findCommonPrefix() {
    private void findCommonPrefix() {
        prefixIndex = 0;
        int end = Math.min(expected.length(), actual.length());
        for (; prefixIndex < end; prefixIndex++) {
            if (expected.charAt(prefixIndex) != actual.charAt(prefixIndex))
                break;
        }
    }

    // 期望值和实际值不等于空，需要压缩组装
    private boolean canBeCompacted() {
        return expected != null && actual != null && !areStringsEqual();
    }

    // 压缩组装结果
    private String compactString(String source) {
        //String result = DELTA_START + source.substring(prefix, source.length() - suffix + 1) + DELTA_END;
        String result = DELTA_START + source.substring(prefixIndex, source.length() - prefixIndex + 1) + DELTA_END;
        //if (prefix > 0)
        if (prefixIndex > 0)
            result = computeCommonPrefix() + result;
        //if (suffix > 0)
        if (prefixIndex > 0)
            result = result + computeCommonSuffix();
        return result;
    }

    // 计算前缀
    private String computeCommonPrefix() {
        //return (prefix > contextLength ? ELLIPSIS : "") + expected.substring(Math.max(0, prefix - contextLength), prefix);
        return (prefixIndex > contextLength ? ELLIPSIS : "") + expected.substring(Math.max(0, prefixIndex - contextLength), prefixIndex);
    }

    // 计算后缀
    private String computeCommonSuffix() {
        //int end = Math.min(expected.length() - suffix + 1 + contextLength, expected.length());
        int end = Math.min(expected.length() - suffixIndex + 1 + contextLength, expected.length());
        //return expected.substring(expected.length() - suffix + 1, end) + (expected.length() - suffix + 1 < expected.length() - contextLength ? ELLIPSIS : "");
        return expected.substring(expected.length() - suffixIndex + 1, end) + (expected.length() - suffixIndex + 1 < expected.length() - contextLength ? ELLIPSIS : "");
    }

    private boolean areStringsEqual() {
        return expected.equals(actual);
    }
}