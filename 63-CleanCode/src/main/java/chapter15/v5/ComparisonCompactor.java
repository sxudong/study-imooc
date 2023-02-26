package chapter15.v5;

import junit.framework.Assert;

/**
 * 改进 代码清单 15-2  p244
 * 否定式稍微比肯定式难理解一些[G29]避免否定性条件。我们把 if 语句放到上头，调转条件判断。
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

    public ComparisonCompactor(int contextLength, String expected, String actual) {
        this.contextLength = contextLength;
        this.expected = expected;
        this.actual = actual;
    }

    public String compact(String message) {
//        if(shouldNotCompact())
//            return Assert.format(message, expected, actual);
//
//        findCommonPrefix();
//        findCommonSuffix();
//        String compactExpected = compactString(expected);
//        String compactActual = compactString(actual);
//        return Assert.format(message, compactExpected, compactActual);

        if(canBeCompacted()) {
            findCommonPrefix();
            findCommonSuffix();
            String compactExpected = compactString(expected);
            String compactActual = compactString(actual);
            return Assert.format(message, compactExpected, compactActual);
        } else {
            return Assert.format(message, expected, actual);
        }
    }

//    private boolean shouldNotCompact() {
//        return expected == null || actual == null || areStringsEqual();
//    }
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
        suffix = 0;
        int end = Math.min(expected.length(), actual.length());
        for (; prefix < end; prefix++) {
            if (expected.charAt(prefix) != actual.charAt(prefix)) {
                break;
            }
        }
    }

    // 查找后缀
    private void findCommonSuffix() {
        int expectedSuffix = expected.length() - 1;
        int actualSuffix = actual.length() - 1;
        for (; actualSuffix >= prefix && expectedSuffix >= prefix; actualSuffix--, expectedSuffix--) {
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