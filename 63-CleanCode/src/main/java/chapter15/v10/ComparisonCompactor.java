package chapter15.v10;

import junit.framework.Assert;

/**
 * 改进 代码清单 15-2  p247
 *
 */
public class ComparisonCompactor {

    private static final String ELLIPSIS = "…";
    private static final String DELTA_END = "]";
    private static final String DELTA_START = "[";

    private int contextLength;
    private String expected;
    private String actual;
    private int prefixIndex;
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

    private void compactExpectedAndActual() {
        findCommonPrefixAndSuffix();
        compactExpected = compactString(expected);
        compactActual = compactString(actual);
    }

    /**
     * 这样好多了。它暴露出 suffixIndex 其实是后缀的长度，而且名字没起好，对于 prefix 也是如此。
     * 虽然在那种情形下 index 和 length 是同义的，但使用 length 一词更有一贯性。问题在于，
     * suffixIndex 变量并不是从 0 开始，而是从 1 开始，而从 1 开始的，所以并非真正的长度。
     * 这也是 computeCommonSuffix() 中那些 +1 存在的原因[G33]封装边界条件。来修正它们吧，
     * 修正结果就是 代码清单 15-4。
     */
    // 查找前缀和后缀
    private void findCommonPrefixAndSuffix() {
        findCommonPrefix();
        int expectedSuffix = expected.length() - 1;
        int actualSuffix = actual.length() - 1;
        for (;actualSuffix >= prefixIndex && expectedSuffix >= prefixIndex;
             actualSuffix--, expectedSuffix--) {
            if (expected.charAt(expectedSuffix) != actual.charAt(actualSuffix))
                break;
        }
        suffixIndex = expected.length() - expectedSuffix;
    }

    // 查找前缀
    private void findCommonPrefix() {
        prefixIndex = 0;
        int end = Math.min(expected.length(), actual.length());
        for (; prefixIndex < end; prefixIndex++) {
            if (expected.charAt(prefixIndex) != actual.charAt(prefixIndex)) {
                break;
            }
        }
    }

    // 期望值和实际值不等于空，需要压缩组装
    private boolean canBeCompacted() {
        return expected != null && actual != null && !areStringsEqual();
    }

    // 压缩组装结果
    private String compactString(String source) {
        String result = DELTA_START + source.substring(prefixIndex, source.length() - prefixIndex + 1) + DELTA_END;
        if (prefixIndex > 0)
            result = computeCommonPrefix() + result;
        if (prefixIndex > 0)
            result = result + computeCommonSuffix();
        return result;
    }

    // 计算前缀
    private String computeCommonPrefix() {
        return (prefixIndex > contextLength ? ELLIPSIS : "")
                + expected.substring(Math.max(0, prefixIndex - contextLength), prefixIndex);
    }

    // 计算后缀
    private String computeCommonSuffix() {
        int end = Math.min(expected.length() - suffixIndex + 1 + contextLength, expected.length());
        return expected.substring(expected.length() - suffixIndex + 1, end)
                + (expected.length() - suffixIndex + 1 < expected.length() - contextLength ? ELLIPSIS : "");
    }

    private boolean areStringsEqual() {
        return expected.equals(actual);
    }
}