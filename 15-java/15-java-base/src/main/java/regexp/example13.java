package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regular Expressions —— back向前引用
 *
 */
public class example13 {
	public static void main(String[] args) {
		// back refenrences 向前引用
		// (\\d\\d)找到的是12，\\1第一个组捕获之后的那个字符串是“1”。
		// 这里第一个组捕获的是“12”，12之后的字符串是“1”
		Pattern p = Pattern.compile("(\\d\\d)\\1");
		String s = "1212";
		Matcher m = p.matcher(s);
		p(m.matches()); //true

		//这里两个组，看到一个左括号就是一个组
		//第一个组是“1”，第二个组是“2”，第三个字符是“1”与模板模式要求匹配的“2”不匹配
		Pattern p2 = Pattern.compile("(\\d(\\d))\\2");
		String s2 = "1212";
		Matcher m2 = p2.matcher(s2);
		p(m2.matches()); //false

		Pattern p3 = Pattern.compile("(\\d(\\d))\\2");
		String s3 = "122";
		Matcher m3 = p3.matcher(s3);
		p(m3.matches()); //true
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
