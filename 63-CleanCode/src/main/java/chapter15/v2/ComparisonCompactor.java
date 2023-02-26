package chapter15.v2;

import junit.framework.Assert;

/**
 * 改进 代码清单 15-2  p243
 * 先删除所有的 f 前缀
 */
public class ComparisonCompactor {

    private static final String ELLIPSIS = "…";
    private static final String DELTA_END = "]";
    private static final String DELTA_START = "[";

    //private int fContextLength;
    //private String fExpected;
    //private String fActual;
    //private int fPrefix;
    //private int fSuffix;
    private int contextLength;
    private String expected;
    private String actual;
    private int prefix;
    private int suffix;

    public ComparisonCompactor(int contextLength, String expected, String actual) {
//        fContextLength = contextLength;
//        fExpected = expected;
//        fActual = actual;
        this.contextLength = contextLength;
        this.expected = expected;
        this.actual = actual;
    }

    public String compact(String message) {
//        if (fExpected == null || fActual == null || areStringsEqual())
//            return Assert.format(message, fExpected, fActual);
        if (expected == null || actual == null || areStringsEqual())
            return Assert.format(message, expected, actual);

        findCommonPrefix();
        findCommonSuffix();
//        String expected = compactString(fExpected);
//        String actual = compactString(fActual);
        String expected = compactString(this.expected);
        String actual = compactString(this.actual);
        return Assert.format(message, expected, actual);
    }

    // 压缩组装结果
    private String compactString(String source) {
        //String result = DELTA_START + source.substring(fPrefix, source.length() - fSuffix + 1) + DELTA_END;
        String result = DELTA_START + source.substring(prefix, source.length() - suffix + 1) + DELTA_END;
        //if (fPrefix > 0)
        if (prefix > 0)
            result = computeCommonPrefix() + result;
        //if (fSuffix > 0)
        if (suffix > 0)
            result = result + computeCommonSuffix();
        return result;
    }

    // 查找前缀
    private void findCommonPrefix() {
        //fPrefix = 0;
        suffix = 0;
        //int end = Math.min(fExpected.length(), fActual.length());
        int end = Math.min(expected.length(), actual.length());
        //for (; fPrefix < end; fPrefix++) {
        for (; prefix < end; prefix++) {
            //if (fExpected.charAt(fPrefix) != fActual.charAt(fPrefix))
            if (expected.charAt(prefix) != actual.charAt(prefix)) {
                break;
            }
        }
    }

    // 查找后缀
    private void findCommonSuffix() {
//        int expectedSuffix = fExpected.length() - 1;
//        int actualSuffix = fActual.length() - 1;
//        for (;
//             actualSuffix >= fPrefix && expectedSuffix >= fPrefix;
//             actualSuffix--, expectedSuffix--) {
//            if (fExpected.charAt(expectedSuffix) != fActual.charAt(actualSuffix))
//                break;
//        }
//        fSuffix = fExpected.length() - expectedSuffix;
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
//        return (fPrefix > fContextLength ? ELLIPSIS : "") +
//                fExpected.substring(Math.max(0, fPrefix - fContextLength), fPrefix);
        return (prefix > contextLength ? ELLIPSIS : "") +
                expected.substring(Math.max(0, prefix - contextLength), prefix);
    }

    // 计算后缀
    private String computeCommonSuffix() {
//        int end = Math.min(fExpected.length() - fSuffix + 1 + fContextLength,
//                fExpected.length());
//        return fExpected.substring(fExpected.length() - fSuffix + 1, end) +
//                (fExpected.length() - fSuffix + 1 < fExpected.length() - fContextLength ? ELLIPSIS : "");
        int end = Math.min(expected.length() - suffix + 1 + contextLength,
                expected.length());
        return expected.substring(expected.length() - suffix + 1, end) +
                (expected.length() - suffix + 1 < expected.length() - contextLength ? ELLIPSIS : "");
    }

    private boolean areStringsEqual() {
        //return fExpected.equals(fActual);
        return expected.equals(actual);
    }
}