package chapter15.v11;

import junit.framework.Assert;

/**
 * 代码清单 15-4 (过渡版本) p247
 *    我们用 charFromEnd() 中的那个 -1 替代了 computeCommonSuffix() 中的一堆 +1，
 * 前者更为合理，suffixOverlapsPrefix() 中的两个“<=”操作符也同理。这样我们就能
 * 修改 suffixIndex 和 suffixLength 的名称，极大的提升了代码的可读性。
 *    不过还有一个问题。在消灭那些 +1 时，我注意到 compactString() 中的以下代码：
 *         if(suffixLength > 0)
 *    看看代码清单 15-4 中的这行代码。因为 suffixLength 现在要比原本少 1，所以我们应该
 * 把 “>” 操作符改为 “>=” 操作符。那本无道理，不过现在却有意义！这表示这么做没道理，而且可
 * 能是缺陷。嗯，也不算是个缺陷。从之前的分析中我们可以看到，if 语句现在会放置添加长度为零的
 * 后缀。在作出修改之前，if 语句没有作用，因为 suffixIndex 永不会小于 1。
 *    这说明 compactString() 中的两个 if 语句都有问题！看起来它们都该被删除。所以，我们将
 * 其注释掉，运行测试。测试通过了！那就重新构建 compactString()，删除没用的 if 语句，将函数
 * 改得更加简洁[G9]死代码。
 *    这样就好多了！现在我们看到，compactString() 函数只是把片段组合起来。我们甚至可以让它更
 * 清晰，还有许多细微的整理工作可做。与其拖着你遍历剩下的那些修改，我更愿意直接展示代码清单 15-5
 * 中的结果。
 */
public class ComparisonCompactor {

    private static final String ELLIPSIS = "…";
    private static final String DELTA_END = "]";
    private static final String DELTA_START = "[";
    private int contextLength;
    private String expected;
    private String actual;
    //private int prefixIndex;
    //private int suffixIndex;
    private int prefixLength;
    private int suffixLength;

    private String compactExpected;
    private String compactActual;

    public String formatCompactedComparison(String message) {
        if(canBeCompacted()) {
            compactExpectedAndActual();
            return Assert.format(message, compactExpected, compactActual);
        } else {
            return Assert.format(message, compactExpected, compactActual);
        }
    }

    // 期望值和实际值不等于空，需要压缩组装
    private boolean canBeCompacted() {
        return expected != null && actual != null && !areStringsEqual();
    }

    private boolean areStringsEqual() {
        return expected.equals(actual);
    }

    private void compactExpectedAndActual() {
        findCommonPrefixAndSuffix();
        compactExpected = compactString(expected);
        compactActual = compactString(actual);
    }

    // 查找前缀和后缀（找到前缀字符串和后缀字符串的长度）
    private void findCommonPrefixAndSuffix() {
        findCommonPrefix();
        suffixLength = 0;
        for (; !suffixOverlapsPrefix(suffixLength); suffixLength++) {
            if (charFromEnd(expected, suffixLength) != charFromEnd(actual, suffixLength))
                break;
        }
    }

    // 查找前缀（找到前缀字符串的长度）
    private void findCommonPrefix() {
        prefixLength = 0;
        int end = Math.min(expected.length(), actual.length());
        for (; prefixLength < end; prefixLength++)
            if (expected.charAt(prefixLength) != actual.charAt(prefixLength)){
                break;
            }
    }

    // ########### add ###########
    // 从字符串倒数数第几个字符之后的那个字符，如 charFromEnd(“abcdefg”, 2)，结果是 e
    private char charFromEnd(String s, int i) {
        return s.charAt(s.length() - i - 1);
    }

    // 后缀suffix [重叠 Overlaps] 前缀Prefix
    private boolean suffixOverlapsPrefix(int suffixLength) {
        return actual.length() - suffixLength <= prefixLength || expected.length() - suffixLength <= prefixLength;
    }
    // ###########################

    // 压缩组装结果
    private String compactString(String source) {
        String result = DELTA_START + source.substring(prefixLength, source.length() - suffixLength) + DELTA_END;
        if (prefixLength > 0)
            result = computeCommonPrefix() + result;
        if (suffixLength > 0)
            result = result + computeCommonSuffix();
        return result;
    }

    // 计算前缀（组装调用）
    private String computeCommonPrefix() {
        return (prefixLength > contextLength ? ELLIPSIS : "")
                + expected.substring(Math.max(0, prefixLength - contextLength), prefixLength);
    }

    // 计算后缀（组装调用）
    private String computeCommonSuffix() {
        int end = Math.min(expected.length() - suffixLength + contextLength, expected.length());
        return expected.substring(expected.length() - suffixLength, end)
                + (expected.length() - suffixLength < expected.length() - contextLength ? ELLIPSIS : "");
    }
}