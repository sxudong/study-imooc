package regexp;


/**
 * Regular Expressions  —— POSIX Style（不推荐）
 * POSIX是Uniux操作系统的一套标准
 *
 * POSIX 字符类（仅 US-ASCII）
 * 		\p{Lower} 小写字母字符：[a-z]
 * 		\p{Upper} 大写字母字符：[A-Z]
 * 		\p{ASCII} 所有 ASCII：[\x00-\x7F]
 * 		\p{Alpha} 字母字符：[\p{Lower}\p{Upper}]
 * 		\p{Digit} 十进制数字：[0-9]
 * 		\p{Alnum} 字母数字字符：[\p{Alpha}\p{Digit}]
 * 		\p{Punct} 标点符号：!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
 * 		\p{Graph} 可见字符：[\p{Alnum}\p{Punct}]
 * 		\p{Print} 可打印字符：[\p{Graph}\x20]
 * 		\p{Blank} 空格或制表符：[ \t]
 * 		\p{Cntrl} 控制字符：[\x00-\x1F\x7F]
 * 		\p{XDigit} 十六进制数字：[0-9a-fA-F]
 * 		\p{Space} 空白字符：[ \t\n\x0B\f\r]
 */
public class example5 {
	public static void main(String[] args) {
		//POSIX Style 不推荐这么写
		//p("a".matches("\\p{Lower}"));
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
