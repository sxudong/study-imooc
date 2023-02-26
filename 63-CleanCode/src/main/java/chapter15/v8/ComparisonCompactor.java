package chapter15.v8;

import junit.framework.Assert;

/**
 * 改进 代码清单 15-2  p245-p246
 * 注意，这要求我们向成员变量举荐 compactExpected 和 compactActual。我不喜欢新
 * 函数最后两行返回变量的方式，但前两个可不是这样。它们没采用一以贯之的约定[G11]前后不一致。
 * 我们应该修改 findCommonPrefix() 和 findCommonSuffix()，分别返回前缀和后缀值。
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

    // 我们还应该修改成员变量的名称，使之更准确一点[N1]采用描述性的名称，毕竟它们都是索引。
    private void compactExpectedAndActual() {
        // findCommonPrefix();
        // findCommonSuffix();
        int prefixIndex = findCommonPrefix();
        // 仔细检查 findCommonSuffix， 其中隐藏了一个时序性耦合[G31]掩蔽时序耦合，该函数它依赖
        // prefixIndex 是由 findCommonPrefix() 计算得来的事实。如果这两个方法不按这样的顺序调用，
        // 调试就会变得困难。为了暴露这个时序性耦合，我们将 prefixIndex 作为 findCommonSuffix() 的参数。
        // 我对这样的方式不太满意，因为传递 prefixIndex 参数有些随意[G32]别随意，该参数成功维持了执行次序，
        // 但对于解释排序的需要却毫无作用。其程序员可能会抹杀我们刚完成的工作，因为并没有迹象说明该参数确属必
        // 要。所以还是采取别的做法吧。
        int suffixIndex = findCommonSuffix(prefixIndex);
        compactExpected = compactString(expected);
        compactActual = compactString(actual);
    }

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
    //private void findCommonPrefix() {
    private int findCommonPrefix() {
        //suffix = 0;
        int prefixIndex = 0;
        int end = Math.min(expected.length(), actual.length());
        //for (; prefix < end; prefix++) {
        for (; prefixIndex < end; prefixIndex++) {
            //if (expected.charAt(prefix) != actual.charAt(prefix))
            if (expected.charAt(prefixIndex) != actual.charAt(prefixIndex)) {
                break;
            }
        }
        return prefixIndex;
    }


    // 查找后缀
    //private void findCommonSuffix() {
    private int findCommonSuffix(Integer prefixIndex) {
        int expectedSuffix = expected.length() - 1;
        int actualSuffix = actual.length() - 1;
        for (;actualSuffix >= prefixIndex && expectedSuffix >= prefixIndex; actualSuffix--, expectedSuffix--) {
            if (expected.charAt(expectedSuffix) != actual.charAt(actualSuffix))
                break;
        }
        //suffix = expected.length() - expectedSuffix;
        return suffix = expected.length() - expectedSuffix;
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