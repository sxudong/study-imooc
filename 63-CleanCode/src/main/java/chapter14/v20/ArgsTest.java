package chapter14.v20;

import junit.framework.TestCase;

/**
 * https://github.com/glen9527/Clean-Code-zh
 */
public class ArgsTest extends TestCase {

    // 检测 double 参数是否正常工作。
    public void testSimpleDoublePresent() throws Exception {
        Args args = new Args("x##", new String[]{"-x", "42.3"});
        assertEquals(1, args.cardinality());
        assertTrue(args.has('x'));
        assertEquals(42.3, args.getDouble('x'), .001);
    }

    // 用来检测在向 ## 参数传递一个不可解析的字符串时是否会返回错误
    public void testInvalidDouble() throws Exception {
        Args args = new Args("x##", new String[] {"-x","Forty two"});
        assertFalse(args.isValid());
        assertEquals(0, args.cardinality());
        assertFalse(args.has('x'));
        assertEquals(0, args.getInt('x'));
        assertEquals("Argument -x expects a double but was 'Forty two'.",
        args.errorMessage());
    }

    // 测试确保我们正确检测到遗漏的 double 参数
    public void testMissingDouble() throws Exception {
        Args args = new Args("x##", new String[]{"-x"});
        assertFalse(args.isValid());
        assertEquals(0, args.cardinality());
        assertFalse(args.has('x'));
        assertEquals(0.0, args.getDouble('x'), 0.01);
        assertEquals("Could not find double parameter for -x.", args.errorMessage());
    }
}
