package regexp;


/**
 * Regular Expressions  —— 边界匹配器 boundary
 *
 * 边界匹配器
 * 		^    行的开头
 * 		$    行的结尾
 * 		\b   单词边界
 * 		\B   非单词边界
 * 		\A   输入的开头
 * 		\G   上一个匹配的结尾
 * 		\Z   输入的结尾，仅用于最后的结束符（如果有的话）
 * 		\z   输入的结尾
 */
public class example6 {
	public static void main(String[] args) {
		//开头第一个字母是h, . 代表任意字符， * 代表后面跟着零个或多个字符
		p("hello sir".matches("^h.*")); //true
		// . 任意字符，* 代表后面跟着零个或多个字符，$ 结尾。匹配以“ir”结尾的字符
		p("hello sir".matches(".*ir$")); //true
		// 以h为开头,1到3为字母a到z的字符,{1,3}匹配至少 1 次，至多 3 次。
		// 后面跟着一个o，空格是单词边界，各种各样的特殊字符，换行符都是边界。再后面匹配任意多个字符。
		p("hello sir".matches("^h[a-z]{1,3}o\\b.*")); //true
		p("hellosir".matches("^h[a-z]{1,3}o\\b.*")); //false

		// whilte lines 空白行
		// \s  匹配任何空白字符
		// 开头是一个空白符，不是一个换行符，出现0次或者多次，末尾紧跟一个换行符
		p(" \n".matches("^[\\s&&[^\\n]]*\\n$")); //true
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
