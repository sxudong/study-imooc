package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regular Expressions —— 特殊构造（非捕获）
 *
 * non-capturing groups 特殊构造（非捕获）
 * 		(?:X) X，X是匹配的模板表达式，逆向环视时
 * 		(?idmsux-idmsux)  Nothing，但是将匹配标志i d m s u x on - off
 * 		(?idmsux-idmsux:X)   X，作为带有给定标志 i d m s u x on - off
 *      (?=X) X， 顺序环视 lookahead 从前往后看
 * 		(?!X) X， 环视 lookahead 从前往后看
 * 		(?<=X) X，逆序环视 lookbehind 从后面往前看
 * 		(?<!X) X，否定环视 lookbehind 从后面往前看
 * 		(?>X) X， 作为独立的非捕获组
 *   https://blog.csdn.net/qq_45463524/article/details/114279726
 */
public class example12 {

	public static void main(String[] args) {

		//non-capturing groups
		Pattern p = Pattern.compile(".{3}"); //匹配3个字符
		String s = "44a66b";
		Matcher m = p.matcher(s);
		while(m.find()) {
			p(m.group()); //444
		}
		/* Output:
		 44a
		 66b
		 */

		System.out.println();

		/**
		 * (?=a)放在前面 a 算在 group 之中
		 * (?=a)放在后面 a 不算在 group 之中 lookahead 从头开始看,尾巴不算。
		 * 符合条件不捕获，不符合条件捕获。
		 */
		// 正则表达式引擎从左向右扫描，扫描到 “444a66b” 中的第3个字符时，然后执行环视，
		// (?=a）表示顺序环视，也就是向字符串右边看，观察后面的字符是否是“a”，如果是，
		// 则匹配成功；如果不是，则丢弃这个匹配。
		Pattern p2 = Pattern.compile(".{3}(?=a)"); // 3个字符，后面一个字符不捕获 a
		String s2 = "4444a66b";
		Matcher m2 = p2.matcher(s2);
		while(m2.find()) {
			p(m2.group()); //444
		}

		System.out.println();

		/**
		 * (?=a)写在前面或后面结果不一样
		 * (?=a)放在前面 a 算在 group 之中
		 * (?=a)放在后面 a 不算在 group 之中
		 */
		Pattern p3 = Pattern.compile("(?=a).{3}"); //捕获以"a"开头的3个字符
		String s3 = "444a66b";
		Matcher m3 = p3.matcher(s3);
		while(m3.find()) {
			p(m3.group()); //a66
		}

		System.out.println();

		/**
		 * （?!a）在前面
		 */
		Pattern p4 = Pattern.compile("(?!a).{3}"); //!a 前面不能为“a”的
		String s4 = "444a66b";
		Matcher m4 = p4.matcher(s4);
		while(m4.find()) {
			p(m4.group());
			/* Output:
			 444
			 66b
			 */
		}

		System.out.println();

		/**
		 * （?!a）在前面
		 */
		Pattern p5 = Pattern.compile(".{3}(?!a)"); //后面跟着的不是“a”
		String s5 = "444a66b";
		Matcher m5 = p5.matcher(s5);
		while(m5.find()) {
			p(m5.group());
			/* Output:
			 44a
			 66b
			 */
		}

		System.out.println();

		/**
		 * （?<!a）
		 */
		Pattern p6 = Pattern.compile(".{3}(?<!a)"); //从后往前数不是“a”的
		String s6 = "444a66b";
		Matcher m6 = p6.matcher(s6);
		while(m6.find()) {
			p(m6.group());
			/* Output:
			 444
			 a66
			 */
		}

		System.out.println();

		/**
		 * （?<=a）
		 */
		Pattern p7 = Pattern.compile(".{3}(?<=a)"); //从后往前数包含“a”的
		String s7 = "444a66b";
		Matcher m7 = p7.matcher(s7);
		while(m7.find()) {
			p(m7.group()); //44a
		}
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
