package regexp;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Regular Expressions 正则表达式 —— 字符串处理利器
 *
 * 用途：
 * 		字符串匹配
 * 	    字符串查找
 * 	    字符串替换
 * 例如：
 *      IP地址是否正确
 *      从网页中揪出email地址
 *      从网页中揪出链接等
 *
 * 主要的类：
 * 		java.lang.String
 * 	    java.util.regex.Pattern
 * 	    java.util.regex.Matcher
 */
public class example1 {
	/**
	 * 简单认识正则表达式的概念
	 *    参考 JDK_API6.0.CHM java.util.regex.Pattern 说明
 	 */
	public static void main(String[] args) {
		// . 代表任意字符
		p("abc".matches("...")); //true
		// 将数字替换成“-”  “\\d” 代表数字
		p("a8729a".replaceAll("\\d", "-")); //a----a


		// 编译生成一个"[a-z]{3}"模式，匹配一个具有3个字符的字符串，3个字符都是a到z
		Pattern p = Pattern.compile("[a-z]{3}");
		// 进行模式匹配，匹配之后的结果存储在 Matcher 对象里，Matcher中文叫匹配器
		Matcher m = p.matcher("fgh");
		p(m.matches()); //true


		//这一句相当于前面3句话
		p("fgha".matches("[a-z]{3}")); //false

		/**
		 * 3句话的好处:
		 * 		1 效率高，它先编译了。
		 * 		2 Pattern 和 Matcher 提供了很多重要的功能
		 * 	      这是简单的	matchers 所不具备的。
		 */
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
/* Output:
true
a----a
true
false
 */