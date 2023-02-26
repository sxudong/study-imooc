package chapter14.v19;

import junit.framework.TestCase;

/**
 * https://github.com/glen9527/Clean-Code-zh
 */
public class ArgsTest extends TestCase {

    // 增加一个新的测试用例，检测 double 参数是否正常工作。
    public void testSimpleDoublePresent() throws Exception {
        Args args = new Args("x##", new String[]{"-x", "42.3"});
        assertEquals(1, args.cardinality());
        assertTrue(args.has('x'));
        assertEquals(42.3, args.getDouble('x'), .001);
    }

}
