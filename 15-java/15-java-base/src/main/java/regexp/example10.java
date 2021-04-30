package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regular Expressions —— Group()捕获给定组序列
 *
 */
public class example10 {
	public static void main(String[] args) {
		//以小括号来分组，分了几组，就看有几个小括号就行了。
		//第一组匹配3~5个数字，第二组匹配2个小字字母
		Pattern p = Pattern.compile("(\\d{3,5})([a-z]{2})");
		String s = "123aa-34345bb-234cc-00";
		Matcher m = p.matcher(s);
		while(m.find()) {
			//p(m.group(1)); //组1
			/* Output:
			  123
			  34345
			  234
			 */
			//p(m.group(2)); //组2
			/* Output:
			  aa
			  bb
			  cc
			 */
			p(m.group());
			/* Output:
		      123aa
			  34345bb
			  234cc
			*/
		}
	}

	public static void p(Object o) {
		System.out.println(o);
	}
	/*
	123    aa
	34345  bb
	234    cc
	 */
}