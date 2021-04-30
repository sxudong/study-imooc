package regexp;


/**
 * Regular Expressions —— 练习
 */
public class example7 {

	public static void main(String[] args) {

		//任意多个字符，4个数字，.一个字符
		p("aaa 8888c".matches(".*\\d{4}.")); //true
		//任意多个字符，单词边界，4个数字，最后.一个字符
		p("aaa 8888c".matches(".*\\b\\d{4}.")); //true
		//任意多个字符，4个数字，.一个字符
		p("aaa8888c".matches(".*\\d{4}.")); //true
		p("aaa8888c".matches(".*\\b\\d{4}.")); //false

		//练习用正则表达式写Email地址
		p("asdfasdfsafsf@dsdfsdf.com".matches("[\\w[.-]]+@[\\w[.-]]+\\.[\\w]+"));
	}

	public static void p(Object o) {
		System.out.println(o);
	}

}
