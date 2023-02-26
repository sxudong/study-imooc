package chapter15;

import junit.framework.Assert;

/**
 * 代码清单 15-5 最终版本
 * https://github.com/glen9527/Clean-Code-zh
 *   这的确很漂亮。模块分解成了一组分析函数和一组合成函数。它们以一种拓扑方式排序，
 * 每个函数的定义都正好在其被调用的位置后面。所有的分析函数都先出现， 而所有的合成
 * 函数都最后出现。
 *   仔细阅读，你会发现我推翻了在本章较前位置做出的几个决定。例如，我将几个分解出
 * 来的方法重新内联为  formatCompactedComparison() ，修改了 shouldNotBeCompacted()
 * 表达的意思，这种做法很常见。重构常会导致另一次推翻此次重构的重构。重构是一种不停试错的迭代
 * 过程，不可避免地集中于我们认为是专业人员该做的事。
 */
public class ComparisonCompactor {

    private static final String ELLIPSIS = "…";
    private static final String DELTA_END = "]";
    private static final String DELTA_START = "[";
    private int contextLength; // 容器长度
    private String expected;   // 期望的
    private String actual;     // 实际的
    private int prefixLength;  // 前缀
    private int suffixLength;  // 后缀

    public ComparisonCompactor(int contextLength, String expected, String actual) {
        this.contextLength = contextLength;
        this.expected = expected;
        this.actual = actual;
    }

    public String formatCompactedComparison(String message) {
        String compactExpected = expected; // 压缩期望值
        String compactActual = actual;     // 实际期望值
        if (shouldBeCompacted()) { // 期望值与实际值不为空才比较
            findCommonPrefixAndSuffix(); // 计算前缀和后缀长度
            compactExpected = compact(expected); // 组装要打印的期望结果
            compactActual = compact(actual);     // 组装要打印的实际结果
        }
        return Assert.format(message, compactExpected, compactActual);
    }

    // 不等空，需要压缩
    private boolean shouldBeCompacted() {
        return !shouldNotBeCompacted();
    }

    // 等于空，不需要压缩
    private boolean shouldNotBeCompacted() {
        return expected == null || actual == null || expected.equals(actual);
    }

    // 计算前缀长度和后缀长度
    private void findCommonPrefixAndSuffix() {
        findCommonPrefix();

        /**
         * 计算后缀长度
         * 例如：bbbae 和 bbbce
         *  suffixLength = 1
         *  bbbae[3]:a bbbce[3]:c
         */
        suffixLength = 0;
        for (; !suffixOverlapsPrefix(); suffixLength++) { // 如果实际值长度和期望值长度都不 小于等于 前缀长度
            // 从后往前数，如果字母ASCII值不相等，计算后缀长度结束，跳出for循环
            if (charFromEnd(expected, suffixLength) != charFromEnd(actual, suffixLength)) {
                System.out.println("suffixLength = " + suffixLength);
                System.out.println(expected+"["+ (expected.length() - suffixLength - 1) + "]:" + charFromEnd(expected, suffixLength)
                        + " " + actual+"["+ (actual.length() - suffixLength - 1) + "]:"  + charFromEnd(actual, suffixLength));
                break;
            }
        }
    }

    private char charFromEnd(String s, int i) {
        return s.charAt(s.length() - i - 1);
    }

    private boolean suffixOverlapsPrefix() {
        return actual.length() - suffixLength <= prefixLength || expected.length() - suffixLength <= prefixLength;
    }

    /**
     * 计算前缀长度
     * 例如：bbbae 和 bbbce 相同的前缀字母长度是 3
     *   prefixLength = 3
     *   bbbae[3]:a bbbce[3]:c
     */
    private void findCommonPrefix() {
        prefixLength = 0;
        int end = Math.min(expected.length(), actual.length()); // 期望值与实际值最小长度
        for (; prefixLength < end; prefixLength++)
            if (expected.charAt(prefixLength) != actual.charAt(prefixLength)) { // 比较两个字母的 ASSIC 码是否相等
                System.out.println("prefixLength = " + prefixLength);
                System.out.println(expected + "["+prefixLength+"]:" + expected.charAt(prefixLength) + " " + actual + "["+prefixLength+"]:" + actual.charAt(prefixLength));
                break;
            }
    }

    private String compact(String s) {
        return new StringBuilder()
                .append(startingEllipsis())
                .append(startingContext())
                .append(DELTA_START)
                .append(delta(s))
                .append(DELTA_END)
                .append(endingContext())
                .append(endingEllipsis())
                .toString();
    }

    private String startingEllipsis() {
        return prefixLength > contextLength ? ELLIPSIS : "";
    }

    private String startingContext() {
        int contextStart = Math.max(0, prefixLength - contextLength);
        int contextEnd = prefixLength;
        return expected.substring(contextStart, contextEnd);
    }

    private String delta(String s) {
        int deltaStart = prefixLength;
        int deltaEnd = s.length() - suffixLength;
        return s.substring(deltaStart, deltaEnd);
    }

    private String endingContext() {
        int contextStart = expected.length() - suffixLength;
        int contextEnd =
                Math.min(contextStart + contextLength, expected.length());
        return expected.substring(contextStart, contextEnd);
    }

    private String endingEllipsis() {
        return (suffixLength > contextLength ? ELLIPSIS : "");
    }
}