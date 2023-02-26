package chapter15.v1;

import junit.framework.TestCase;

/**
 * 代码清单 15-1 p238
 * 我们要查看模块，是用来帮忙鉴别字符串比较错误的一段代码，该模块被命名为 ComparisonCompactor。
 * 对于两个不同的字符串，如 ABCDE 和 ABXDE，该模块将用形如 <...B[x]D...> 的字符串来暴露两者的
 * 不同之处。
 * 我们可以做进一步解释，但测试用例会更有说服力。看看代码清单 15-1，我们将深入了解到该块块满足的需求，
 * 边看代码，边研究该测试的结构，它们能变得更简洁或更明确吗？
 */
public class ComparisonCompactorTest extends TestCase {

    public void testMessage() {
        // compact("a") 可似不要，期望的是b，实际的是c。中括号内代码的是两个字符串里不同的字母。
        String failure = new ComparisonCompactor(0, "b", "c").compact("a");
        assertTrue("a expected:<[b]> but was:<[c]>".equals(failure));
    }

    public void testStartSame() {
        String failure = new ComparisonCompactor(1, "ba", "bc").compact(null);
        assertEquals("expected:<b[a]> but was:<b[c]>", failure);
    }

    public void testEndSame() {
        String failure = new ComparisonCompactor(1, "ab", "cb").compact(null);
        assertEquals("expected:<[a]b> but was:<[c]b>", failure);
    }

    public void testSame() {
        // 期望是 ab，实际也是 ab
        String failure = new ComparisonCompactor(1, "ab", "ab").compact(null);
        assertEquals("expected:<ab> but was:<ab>", failure);
    }

    public void testNoContextStartAndEndSame() {
        String failure = new ComparisonCompactor(0, "abc", "adc").compact(null);
        assertEquals("expected:<…[b]…> but was:<…[d]…>", failure);
    }

    public void testStartAndEndContext() {
        String failure = new ComparisonCompactor(1, "abc", "adc").compact(null);
        assertEquals("expected:<a[b]c> but was:<a[d]c>", failure);
    }

    public void testStartAndEndContextWithEllipses() {
        String failure =
                new ComparisonCompactor(1, "abcde", "abfde").compact(null);
        assertEquals("expected:<…b[c]d…> but was:<…b[f]d…>", failure);
    }

    public void testComparisonErrorStartSameComplete() {
        String failure = new ComparisonCompactor(2, "ab", "abc").compact(null);
        assertEquals("expected:<ab[]> but was:<ab[c]>", failure);
    }

    public void testComparisonErrorEndSameComplete() {
        String failure = new ComparisonCompactor(0, "bc", "abc").compact(null);
        assertEquals("expected:<[]…> but was:<[a]…>", failure);
    }

    public void testComparisonErrorEndSameCompleteContext() {
        String failure = new ComparisonCompactor(2, "bc", "abc").compact(null);
        assertEquals("expected:<[]bc> but was:<[a]bc>", failure);
    }

    public void testComparisonErrorOverlapingMatches() {
        String failure = new ComparisonCompactor(0, "abc", "abbc").compact(null);
        assertEquals("expected:<…[]…> but was:<…[b]…>", failure);
    }

    public void testComparisonErrorOverlapingMatchesContext() {
        String failure = new ComparisonCompactor(2, "abc", "abbc").compact(null);
        assertEquals("expected:<ab[]c> but was:<ab[b]c>", failure);
    }

    public void testComparisonErrorOverlapingMatches2() {
        String failure = new ComparisonCompactor(0, "abcdde",
                "abcde").compact(null);
        assertEquals("expected:<…[d]…> but was:<…[]…>", failure);
    }

    public void testComparisonErrorOverlapingMatches2Context() {
        String failure =
                new ComparisonCompactor(2, "abcdde", "abcde").compact(null);
        assertEquals("expected:<…cd[d]e> but was:<…cd[]e>", failure);
    }

    public void testComparisonErrorWithActualNull() {
        String failure = new ComparisonCompactor(0, "a", null).compact(null);
        assertEquals("expected:<a> but was:<null>", failure);
    }

    public void testComparisonErrorWithActualNullContext() {
        String failure = new ComparisonCompactor(2, "a", null).compact(null);
        assertEquals("expected:<a> but was:<null>", failure);
    }

    public void testComparisonErrorWithExpectedNull() {
        String failure = new ComparisonCompactor(0, null, "a").compact(null);
        assertEquals("expected:<null> but was:<a>", failure);
    }

    public void testComparisonErrorWithExpectedNullContext() {
        String failure = new ComparisonCompactor(2, null, "a").compact(null);
        assertEquals("expected:<null> but was:<a>", failure);
    }

    public void testBug609972() {
        String failure = new ComparisonCompactor(10, "S&P500", "0").compact(null);
        assertEquals("expected:<[S&P50]0> but was:<[]0>", failure);
    }
}