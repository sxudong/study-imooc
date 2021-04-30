package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 初步认识. * + ?
 *
 * Greedy 数量词（手册里的这个X代表前面的表达式，linux和MySQL正则前面都不用这个X来表达，直接省略掉了）
 * 		X? 		X，一次或一次也没有              ？    零次或一次匹配前面的字符或子表达式。
 * 		X* 		X，零次或多次                    *    零次或多次匹配前面的字符或子表达式。
 * 		X+ 		X，一次或多次                    +    一次或多次匹配前面的字符或子表达式。
 * 		X{n} 	X，恰好 n 次                    {n}   n 是非负整数。正好匹配 n 次。
 * 		X{n,} 	X，至少 n 次                    {n,}  n 是非负整数。至少匹配 n 次。
 * 		X{n,m} 	X，至少 n 次，但是不超过 m 次    {n,m} m 和 n 是非负整数，其中 n <= m。匹配至少 n 次，至多 m 次。
 *
 * 	此正则与 MySQL 正则一样
 * 	参见 https://www.runoob.com/java/java-regular-expressions.html
 */
public class example2 {
	public static void main(String[] args) {

		p("a".matches("."));     //true
		p("aa".matches("aa"));   //true
		p("aaaa".matches("a*")); //true
		p("aaaa".matches("a+")); //true
		p("".matches("a*"));     //true
		p("aaaa".matches("a?")); //false
		p("".matches("a?"));     //true
		p("a".matches("a?"));    //true
		p("214523145234532".matches("\\d{3,100}")); //true
		p("192.168.0.aaa".matches("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}")); //false
		// 中括号代表范围
		p("192".matches("[0-2][0-9][0-9]")); //true
	}

	public static void p(Object o) {
		System.out.println(o);
	}
}
