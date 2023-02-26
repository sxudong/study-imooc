
import org.junit.Test;
import java.util.ArrayList;
import static junit.framework.TestCase.fail;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;


/**
 * fail() 尝试捕获并始终失败
 * 如果您要测试的行没有引发任何异常，而您忘记放置fail() ，则测试将通过（假肯定）。
 */
public class Exception2Test {
 
    @Test
    public void testDivisionWithException() {
        try {
            //int i = 1 / 0;
            fail(); //remember this line, else 'may' false positive
        } catch (ArithmeticException e) {
            assertThat(e.getMessage(), is("/ by zero"));
			//assert others
        }
    }
 
    @Test
    public void testEmptyList() {
        try {
            new ArrayList<>().get(0);
            fail();
        } catch (IndexOutOfBoundsException e) {
            assertThat(e.getMessage(), is("Index: 0, Size: 0"));
        }
    }
}